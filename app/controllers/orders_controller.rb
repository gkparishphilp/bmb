class OrdersController < ApplicationController
	before_filter :require_admin, :only => [:admin]
	before_filter :get_form_data, :only => :new
	before_filter :get_ordered
	layout	:set_layout
	
	def admin
		@orders = Order.all.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
	end

	def index
		@orders = @current_user.orders
	end

	def show
		@order = Order.find params[:id] 
=begin
		# todo Need to fix this for anonymous user access
		if @order.user != @current_user 
			pop_flash 'Not your order', :error, @order
			redirect_to @order
		else
			redirect_to @order
		end
=end 
	end


	def new
		@order = Order.new
		unless @current_user.anonymous?
			@billing_addresses = @current_user.billing_addresses
			@shipping_addresses = @current_user.shipping_addresses
		end

		redirect_to root_path if @ordered.is_a? Subscription and @ordered.redemptions_remaining == 0
			
	end

	def check_order
	end

	def create
		@order = Order.new params[:order]
		@order.ip = request.remote_ip
		@order.user = @current_user
		
		# Process coupons
		if !params[:coupon_code].blank? and params[:ordered_type] != 'Subscription'
			if @coupon = Coupon.find_by_code(params[:coupon_code])
				redemption = Redemption.new
				redemption.order = @order
				redemption.coupon = @coupon
				redemption.save
				@order.apply_coupon if @coupon.is_valid? (@order )
			end
		end

		# Get billing address information from form
		if @current_user.billing_addresses.empty?
			#User does not have an existing billing address, so create one from form data		
			unless billing_address = BillingAddress.create(params[:billing_address])
				pop_flash "Billing address needs to be completely filled out", :error, billing_address
			else
				@order.billing_address = billing_address
			end
		else
			if params[:new_billing_address]
				#User has created a new billing address
				unless billing_address = BillingAddress.create(params[:billing_address])
					pop_flash "Billing address needs to be completely filled out", :error, billing_address
				else
					@order.billing_address = billing_address
				end
			else
				#User is using an existing billing address
				@order.billing_address = @current_user.billing_addresses.find params[:order][:billing_address_id]
			end
		end

		# Get shipping address information from form (if it exists)
		if params[:shipping_address] and @current_user.shipping_addresses.empty?
			#User does not have an existing shipping address, so create one from form data 
			unless shipping_address = ShippingAddress.create(params[:shipping_address])
				pop_flash "Shipping address needs to be completely filled out", :error, shippinging_address	
			else
				@order.shipping_address = shipping_address
			end
		elsif params[:shipping_address]
			if params[:new_shipping_address]
				#User has created a new shipping address
				unless shipping_address = ShippingAddress.create(params[:shipping_address])
					pop_flash "Shipping address needs to be completely filled out", :error, shippinging_address	
				else
					@order.shipping_address = shipping_address
				end
			else
				#User is using an existing shipping address
				@order.shipping_address = @current_user.shipping_addresses.find params[:order][:shipping_address_id]
			end
		end

		# Process the order
		if @order.save && @order.purchase
			pop_flash 'Order was successfully processed.'
			@order.update_attributes :status => 'success'
			@order.post_purchase_actions
			redirect_to @order
		else
			pop_flash 'Oooops, order was not saved', :error, @order
			redirect_to new_order_path( :ordered_id => @order.ordered.id, :ordered_type => @order.ordered.class.to_s)
			#TODO send back errors from Paypal here also
		end

	end

private

	def get_form_data
		@months = {'01' => 1, '02' => 2, '03' => 3, '04' => 4, '05' => 5, '06' => 6, '07' => 7, '08' => 8, '09' => 9, '10' => 10, '11' => 11, '12' => 12 }.sort
		@years = {'2010' => 2010, '2011' => 2011, '2012' => 2012, '2013' => 2013, '2014' => 2014, '2015' => 2015, '2016' => 2016,  '2017' => 2017,  '2018' => 2018,  '2019' => 2019,  '2020' => 2020 }.sort
		@states = GeoState.where("country ='US'")
	end

	def get_ordered
		# the sexy way: @ordered = eval "#{params[:ordered_type]}.find params[:ordered_id]" 
		# But a moot point anyway, since only skus can be ordered....
		@ordered = Sku.find params[:sku]
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	

end #End Orders controller

