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

end


