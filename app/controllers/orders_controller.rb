class OrdersController < ApplicationController
	
	before_filter :require_author, :only => [ :admin, :inspect ]
	before_filter :get_form_data, :only => :new
	before_filter :get_sku, :only => [ :new, :go_paypal, :ret_paypal ]
	layout	:set_layout
	helper_method :sort_column, :sort_dir
	
	def admin
		@orders = Order.for_author( @current_author ).search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :page => params[:page], :per_page => 10 )
		render :layout => '3col'
	end
	
	def inspect
		@order = Order.find( params[:id] )
		if @order.sku.owner == @current_author
			render :layout => '3col'
		else
			pop_flash "Not your order", :error
			redirect_to :back
		end
	end

	def index
		@orders = @current_user.orders
	end

	def show
		@order = Order.find params[:id] 
		
		if ( @order.user != @current_user && @order.paypal_express_token.blank? && @order.ip != request.ip )  
			pop_flash 'Not your order', :error
			redirect_to root_path
		end
		
		
	end
	

	def new
		@order = Order.new

		# set order fields if in Dev environment
		if Rails.env.development?
			@order.card_number = '4411037113154626'
			@order.card_cvv = '123'
			@order.card_exp_year = '2013'
		end
		
		#initialize a billing address if the user doesn't have one
		@billing_address = @current_user.billing_address.present? ? @current_user.billing_address : GeoAddress.new( :address_type => 'billing' )
		#setup array of shipping addresses with appended option for new address
		@shipping_addresses_for_select = @current_user.shipping_addresses.map{ |a| [ a.street, a.id ] } + ['New Address']
		# create an empty shipping address in case user wants to enter a new one right on the checkout form
		@shipping_address = GeoAddress.new( :address_type => 'shipping' ) if @sku.contains_merch?
			
	end

	def go_paypal
		price_in_cents = @sku.price
		cancel_return_url = new_order_url(:sku => @sku.id, :author_id => params[:author_id])
		
		response = EXPRESS_GATEWAY.setup_purchase(price_in_cents,
			:ip => request.remote_ip,
			:return_url => ret_paypal_orders_url(:sku => params[:sku], :author_id => params[:author_id]),
			:cancel_return_url => cancel_return_url
		)
		redirect_to EXPRESS_GATEWAY.redirect_url_for( response.token )
		
	end
	
	def ret_paypal
		# method to field response form PayPal
		# set order fields coming back from PayPal
		@order = Order.new
		
		if paypal_token = params[:token]			
			@order.paypal_express_token = params[:token] 
			@order.paypal_express_payer_id = params[:PayerID] 
			@paypal_data = EXPRESS_GATEWAY.details_for( paypal_token )
		else
			pop_flash "There was a problem with your order, please try again later", :error
		end
		
	end
	
	def create
		@order = Order.new params[:order]
		@order.ip = request.remote_ip
		@order.total = Sku.find(params[:order][:sku_id]).price
		
		# setup the order user -- current_user or initialize from email
		if @current_user.anonymous? 
			user = User.find_or_initialize_by_email( :email => params[:order][:email], :name => "#{params[:order][:name]}" )
			if user.save
				@order.user = user
			else
				pop_flash "There was a problem with the Order", :error, user
				if @author.present?
					redirect_to new_author_order_url( @author, :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
				else
					redirect_to new_order_url( :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
				end
				return false
			end
		else
			@order.user = @current_user
		end
		
		# Grab Paypal Express tokens from form
		unless params[:order][:paypal_express_token].blank?
			@order.paypal_express_token = params[:order][:paypal_express_token] 
			@order.paypal_express_payer_id = params[:order][:paypal_express_payer_id] 
		end
		
		# Apply Coupon if present -- actual redemption occurs if order processes successfully
		@order.apply_coupon( @coupon ) if params[:coupon_code].present? and @coupon = Coupon.find_by_code_and_sku_id( params[:coupon_code], params[:order][:sku_id] ) and @coupon.is_valid?( @order.sku )
		
		# setup addresses
		# ...first billing
		if params[:billing_address].present? # because paypal return does not send billing address data
			if @order.user.billing_address.present?
				@order.user.billing_address.attributes = params[:billing_address]
			else
				@order.user.billing_address = GeoAddress.new params[:billing_address]
			end
			if @order.user.billing_address.save
				@order.billing_address = @order.user.billing_address
				@order.billing_address_id = @order.user.billing_address.id
			else
				pop_flash "There was a problem with the Billing Address", :error, @order.user.billing_address
				if @author.present?
					redirect_to new_author_order_url( @author, :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
				else
					redirect_to new_order_url( :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
				end
				return false
			end
		end
		
		# ...ok, now shipping
		if params[:ship_to_bill]
			# set the shipping_id == tp billing if user selects shipt_to_bill
			@order.shipping_address_id = @order.billing_address_id
		elsif @order.shipping_address.nil? && params[:shipping_address].present? 
			# we're only creating a new shipping address if we get params AND the shipping_address_id selector has not
			# set the shipping_id in the order attributes otherwise
			ship_addr = @order.user.shipping_addresses.new( params[:shipping_address] )
			if ship_addr.save
				@order.shipping_address_id = ship_addr.id
			else
				pop_flash "There was a problem with the Shipping Address", :error, ship_addr
				if @author.present?
					redirect_to new_author_order_url( @author, :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
				else
					redirect_to new_order_url( :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
				end
				return false
			end
		end
		
		# Pre-purchase actions such as taxes and shipping calculations
		@order.calculate_taxes
		@order.calculate_shipping
		@order.total = @order.total + @order.tax_amount + @order.shipping_amount
		
		# Process the order
		if @order.save && @order.purchase
			pop_flash 'Order was successfully processed.'
			@order.update_attributes :status => 'success'			
			@order.sku.ownings.create :user => @order.user, :status => 'active'
			@order.redeem_coupon( @coupon ) if @coupon.present? && @coupon.is_valid?(@order.sku )
			@order.calculate_royalties
			@order.send_author_emails
			@order.send_customer_emails
			# todo
			#@order.update_backings  
			#@order.update_author_points 

			if @author.present?
				redirect_to author_order_url( @author, @order, :protocol => SSL_PROTOCOL )
			else
				redirect_to @order
			end

		else
			pop_flash 'Oooops, order could not be processed.', :error, @order
			if @author.present?
				redirect_to new_author_order_url( @author, :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
			else
				redirect_to new_order_url( :sku => @order.sku.id, :protocol => SSL_PROTOCOL )
			end
			#TODO send back errors from Paypal here also
		end
		
		# Post purchase actions
		# Add user to author's subscriber list if the subscribed box is checked
		if @order.subscribe_to_author == 'true'
			subscribing = EmailSubscribing.find_or_create_subscription(@order.sku.owner, @order.user)   # its the actual word 'true', not the boolean true
			subscribing.update_attributes :status => 'subscribed'  # Since the user didn't affirmatively opt-out, set his status to true
		end
		# Decrement inventory
		@order.sku.decrement_inventory  

	end

private

	def get_form_data
		@months = {'01' => 1, '02' => 2, '03' => 3, '04' => 4, '05' => 5, '06' => 6, '07' => 7, '08' => 8, '09' => 9, '10' => 10, '11' => 11, '12' => 12 }.sort
		@years = {'2010' => 2010, '2011' => 2011, '2012' => 2012, '2013' => 2013, '2014' => 2014, '2015' => 2015, '2016' => 2016,  '2017' => 2017,  '2018' => 2018,  '2019' => 2019,  '2020' => 2020 }.sort
		@countries = GeoCountry.where( "id < 4").all + [ GeoCountry.new( :id => nil, :name => "-----------") ] + GeoCountry.order("name asc" ).all
	end

	def get_sku
		# the sexy way: @ordered = eval "#{params[:ordered_type]}.find params[:ordered_id]" 
		# But a moot point anyway, since only skus can be ordered....
		@sku = Sku.find params[:sku] 
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	
	def sort_column
		[ 'created_at' ].include?( params[:sort] ) ? params[:sort] : 'created_at'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'asc'
	end
	
end 

