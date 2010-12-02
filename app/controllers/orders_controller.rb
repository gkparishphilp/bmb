class OrdersController < ApplicationController
	before_filter :require_admin, :only => [:admin]
	before_filter :get_form_data, :only => :new
	before_filter :get_sku, :only => [:new, :paypal_express]
	layout	:set_layout
	
	def admin
		@orders = Order.all.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
	end

	def index
		@orders = @current_user.orders
	end

	def show
		@order = Order.find params[:id] 
		
#Need to fix for anonymous purchases, where @order.user is NEVER the @current_user
=begin
		if @order.user != @current_user 
			pop_flash 'Not your order', :error
			redirect_to @order
		else
			redirect_to @order
		end
=end
	end


	def new
		@order = Order.new
		@order.paypal_express_token = params[:token] if params[:token]
		@order.paypal_express_payer_id = params[:PayerID] if params[:PayerID]
		unless @current_user.anonymous?
			@billing_addresses = @current_user.billing_addresses
			@shipping_addresses = @current_user.shipping_addresses
		end

		#todo need to redirect this to some proper error message
		redirect_to root_path if @ordered.is_a? Subscription and @ordered.redemptions_remaining == 0
			
	end

	def check_order
	end

	def paypal_express
		price_in_cents = @sku.price
		cancel_return_url = new_order_url(:sku => @sku.id)
		
		response = EXPRESS_GATEWAY.setup_purchase(price_in_cents,
			:ip => request.remote_ip,
			:return_url => new_order_url(:sku => params[:sku]),
			:cancel_return_url => cancel_return_url
		)
		redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
		
	end


	def create
		@order = Order.new params[:order]
		@order.ip = request.remote_ip
		
		if @current_user.anonymous? 
			@order.user = User.find_or_initialize_by_email( :email => params[:order][:email], :name => "#{params[:order][:first_name]} #{params[:order][:last_name]}" )
			@order.user.save( false )
			# todo = some validations here and/or punting errors on user up to controller flash
		else
			@order.user = @current_user
		end
		
		# Grab Paypal Express tokens if they exist
		unless params[:order][:paypal_express_token].blank?
			@order.paypal_express_token = params[:order][:paypal_express_token] 
			@order.paypal_express_payer_id = params[:order][:paypal_express_payer_id] 
		end
		
		# Process coupons
		if !params[:coupon_code].blank? and params[:ordered_type] != 'Subscription'
			if @coupon = Coupon.find_by_code(params[:coupon_code])
				@order.apply_coupon( @coupon ) if @coupon.is_valid? (@order.sku )
			end
		end

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



		# Process the order
		if @order.save && @order.purchase
			pop_flash 'Order was successfully processed.'
			@order.update_attributes :status => 'success'
			@order.post_purchase_actions( @current_user )
			@order.redeem_coupon( @coupon ) if @coupon.present? && @coupon.is_valid?(@order.sku )
			redirect_to @order
		else
			pop_flash 'Oooops, order was not saved', :error, @order
			redirect_to new_order_url( :sku => @order.sku.id, :protocol => SSL_PROTOCOL)
			#TODO send back errors from Paypal here also
		end

	end

private

	def get_form_data
		@months = {'01' => 1, '02' => 2, '03' => 3, '04' => 4, '05' => 5, '06' => 6, '07' => 7, '08' => 8, '09' => 9, '10' => 10, '11' => 11, '12' => 12 }.sort
		@years = {'2010' => 2010, '2011' => 2011, '2012' => 2012, '2013' => 2013, '2014' => 2014, '2015' => 2015, '2016' => 2016,  '2017' => 2017,  '2018' => 2018,  '2019' => 2019,  '2020' => 2020 }.sort
		@states = GeoState.where("country ='US'")
	end

	def get_sku
		# the sexy way: @ordered = eval "#{params[:ordered_type]}.find params[:ordered_id]" 
		# But a moot point anyway, since only skus can be ordered....
		@sku = Sku.find params[:sku] 
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	
end #End Orders controller

