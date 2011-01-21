class OrdersController < ApplicationController
	
	before_filter :require_author, :only => [ :admin, :inspect ]
	before_filter :get_form_data, :only => :new
	before_filter :get_sku, :only => [:new, :paypal_express]
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
		
		# set order fields if returning from PayPal
		if params[:token]			
			@order.paypal_express_token = params[:token] 
			@order.paypal_express_payer_id = params[:PayerID] 
			paypal_express_details = EXPRESS_GATEWAY.details_for( params[:token] )
			order_country = paypal_express_details.params["country"]
			render :paypal_express_confirm
			return false
		end
		
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

	def check_order
	end

	def paypal_express
		price_in_cents = @sku.price
		cancel_return_url = new_order_url(:sku => @sku.id, :author_id => params[:author_id])
		
		response = EXPRESS_GATEWAY.setup_purchase(price_in_cents,
			:ip => request.remote_ip,
			:return_url => new_order_url(:sku => params[:sku], :author_id => params[:author_id]),
			:cancel_return_url => cancel_return_url
		)
		redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
		
	end
	
	def create
		@order = Order.new params[:order]
		@order.ip = request.remote_ip
		@order.total = Sku.find(params[:order][:sku_id]).price
		
		# setup the order user -- current_user or initialize from email
		if @current_user.anonymous? 
			user = User.find_or_initialize_by_email( :email => params[:order][:email], :name => "#{params[:order][:first_name]} #{params[:order][:last_name]}" )
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
		
		# ...ok, now shipping
		if params[:ship_to_bill]
			@order.shipping_address_id = @order.billing_address_id
		elsif @order.shipping_address.nil? # because the shipping_address_id selector should just set this in the order attributes otherwise
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
			@order.send_author_emails
			@order.send_customer_emails
			@order.calculate_royalties
			# todo
			#@order.update_backings  
			#@order.update_author_points 
			@order.redeem_coupon( @coupon ) if @coupon.present? && @coupon.is_valid?(@order.sku )

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
		
	end


	def old_create
		@order = Order.new params[:order]
		@order.ip = request.remote_ip
		@order.total = Sku.find(params[:order][:sku_id]).price
				
		if @current_user.anonymous? 
			@order.user = User.find_or_initialize_by_email( :email => params[:order][:email], :name => "#{params[:order][:first_name]} #{params[:order][:last_name]}" )
			@order.user.save( false )
			# todo = some validations here and/or punting errors on user up to controller flash
		else
			@order.user = @current_user
		end
		
		# Grab Paypal Express tokens from form
		unless params[:order][:paypal_express_token].blank?
			@order.paypal_express_token = params[:order][:paypal_express_token] 
			@order.paypal_express_payer_id = params[:order][:paypal_express_payer_id] 
		end
		
		@order.apply_coupon( @coupon ) if params[:coupon_code].present? and @coupon = Coupon.find_by_code_and_sku_id( params[:coupon_code], params[:order][:sku_id] ) and @coupon.is_valid?( @order.sku )
			
		#-----------------------------------------------------------
		# Heinous code for processing shipping and billing addresses
		# todo Refactor if time permits
		#-----------------------------------------------------------
		if @current_user.anonymous?
			# For anonymous users, associate billing and shipping addresses to order, but don't associate to user
				@billing_address = BillingAddress.new params[:billing_address]
				@shipping_address = ShippingAddress.new params[:shipping_address] if params[:shipping_address]
				@order.billing_address = @billing_address
				@order.shipping_address = @shipping_address
		else
			# For non-anonymous users...
			
			#Associating billing address with order and user
			if @order.user.billing_addresses.empty?
				#User does not have an existing billing address, so create one from form data
				unless @billing_address = @order.user.billing_addresses.create( params[:billing_address] )
					pop_flash "Billing address needs to be completely filled out", :error, billing_address
				else
					@billing_address = BillingAddress.new params[:billing_address]
					@order.billing_address = @billing_address
				end
				
			else
				# User has created a new billing address
				if params[:use_new_billing_address]
					#User has created a new billing address
					unless @billing_address = @order.user.billing_addresses.create( params[:billing_address] )
						pop_flash "Billing address needs to be completely filled out", :error, billing_address
					else
						@order.billing_address = @billing_address
					end
				else
					#User has selected an existing address from the drop down
					@order.billing_address = @order.user.billing_addresses.find params[:order][:billing_address_id] if @order.paypal_express_token.blank?
				end
			end
			
			# Associating shipping address with order and user
			if params[:shipping_address] and @order.user.shipping_addresses.empty?
				#User does not have an existing shipping address, so create one from form data 
				unless @shipping_address = @order.user.shipping_addresses.create( params[:shipping_address] )
					pop_flash "Shipping address needs to be completely filled out", :error, shippinging_address	
				else
					@order.shipping_address = @shipping_address
				end
			elsif params[:shipping_address]
				if params[:use_new_shipping_address]
					#User has created a new shipping address
					unless @shipping_address = @order.user.shipping_addresses.create( params[:shipping_address] )
						pop_flash "Shipping address needs to be completely filled out", :error, shippinging_address	
					else
						@order.shipping_address = @shipping_address
					end
				else
					#User is using an existing shipping address
					@order.shipping_address = @order.user.shipping_addresses.find params[:order][:shipping_address_id] if @order.paypal_express_token.blank?
				end
			end
		end

		# Pre-purchase actions such as taxes and shipping calculations		
		@order.tax_amount = @order.calculate_taxes if @order.sku.contains_merch?
		@order.shipping_amount = @order.calculate_shipping if @order.sku.contains_merch?
		@order.total = @order.total + @order.tax_amount + @order.shipping_amount

		# Process the order
		if @order.save && @order.purchase
			pop_flash 'Order was successfully processed.'
			@order.update_attributes :status => 'success'			
			@order.sku.ownings.create :user => @order.user, :status => 'active'
			@order.send_author_emails
			@order.send_customer_emails
			@order.calculate_royalties
			# todo
			#@order.update_backings  
			#@order.update_author_points 
			@order.redeem_coupon( @coupon ) if @coupon.present? && @coupon.is_valid?(@order.sku )

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

