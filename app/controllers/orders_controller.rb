class OrdersController < ApplicationController
	before_filter :require_admin, :only => [:admin]
	before_filter :get_form_data, :only => :new
	before_filter :get_ordered
	
	def admin
		@orders = Order.all.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
	end

	def index
		@orders = @current_user.orders
	end



	def show
		@order = Order.find(params[:id])
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
			@billing_addresses = @current_user.geo_addresses.where("address_type = 'billing'")
			@shipping_addresses = @current_user.geo_addresses.where("address_type = 'shipping'")
		end
	end

	def check_order
	end

	def create
		@order = Order.new params[:order]
		@order.ip = request.remote_ip
		
		if !params[:coupon_code].blank?
			@order.coupon = Coupon.where("code = ?",params[:coupon_code]).first
			@order.apply_coupon if @order.coupon.is_valid?
		end

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
		case params[:ordered_type]
			when 'Merch'
				@ordered = Merch.find params[:ordered_id]
			when 'Bundle'
				@ordered = Bundle.find params[:ordered_id]
		end
	end

end #End Orders controller

