class CouponsController < ApplicationController

	def new
		@coupon = Coupon.new
		@skus = @current_author.skus
		render :layout =>'2col'
	end
	
	def edit
		@coupon = Coupon.find params[:id]
	end
	
	def create
		@coupon = Coupon.new( params[:coupon])
		@coupon.code = @coupon.code.to_lowercase
		@coupon.discount = params[:coupon][:discount].to_f * 100
		@coupon.owner = @current_author
		@coupon.expiration_date = @coupon.expiration_date.end_of_day

		if @coupon.save
			pop_flash 'Coupon was successfully created.'
			redirect_to :back
		else
			pop_flash 'Oooops, coupon not saved...', :error, @coupon
			redirect_to :back
		end
	end
	
	def update
		@coupon = Coupon.new( params[:coupon] )
		
		if @coupon.update_attributes
			pop_flash 'Coupon was successfully updated.'
			redirect_to :back
		else
			pop_flash 'Oooops, coupon not saved...', :error, @coupon
			redirect_to :back
		end
	end
	
	def show
		@coupon = Coupon.find params[:id]
	end
	
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
		@code = params[:code]
		@sku_id = params[:sku_id]
		
		coupon = Coupon.find_by_code_and_sku_id( @code, @sku_id )
		
		sku = Sku.find( @sku_id )
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


