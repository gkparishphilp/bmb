class CouponsController < ApplicationController

	def redeem
		@coupon = params[:coupon]
		@coupon.redeem
	end

	def redeem_code
		@coupon = Coupon.find_by_code( params[:code] )
		@sku = Sku.find @coupon.sku_id
		if @coupon.already_redeemed?
			pop_flash "This code has already been redeemed.", :error
			#todo find the right place to redirect this
			redirect_to root_path
		else
			@user = User.find_by_email params[:email]
			@order = Order.new
			@order.user = @user
			@order.sku = @sku
			@order.email = @user.email
			@order.ip = request.ip
			@order.price = 0
			@order.status = 'success'
			@order.save( false )
			@coupon.redemptions.create :status => 'redeemed', :order_id => @order.id, :user_id => @user.id
			@order.sku.ownings.create :user => @user, :status => 'active'
			
		end
	end
	
	def validate
		coupon = Coupon.find_by_code( params[:code] )
		@code = params[:code]
		@sku_id = params[:sku_id]
		
		sku = Sku.find( params[:sku_id] )
		if coupon && sku
			@response = coupon.is_valid?( sku )
			@discount = coupon.discount_type == 'percent' ? ( coupon.discount.to_f / 100 ) : coupon.discount
			@discount_type = coupon.discount_type
		else
			@response = false
			@discount = 0
			@discount_type = 'none'
		end
		
		render :layout => false
		
	end

end


