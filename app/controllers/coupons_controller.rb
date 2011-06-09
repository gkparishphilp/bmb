class CouponsController < ApplicationController
	before_filter	:get_owner
	before_filter	:get_admin, :only => [ :admin, :new, :edit ]
	before_filter	:check_permissions, :only => [ :admin, :new, :edit ]
	layout			:set_layout
	helper_method	:sort_column, :sort_dir

	def admin
		@coupons = @admin.coupons.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		render :layout => '2col'
	end
	
	
	def new
		@coupon = Coupon.new
		@skus = @current_author.skus
		if @skus.empty?
			pop_flash "You don't have any items to create coupons for!", :error
			redirect_to admin_author_coupons_path( @current_author)
		else
			render :layout =>'2col'
		end
	end
	
	def edit
		@coupon = Coupon.find params[:id]
		@skus = @current_author.skus
		render :layout => '2col'
	end
	
	def create
		@coupon = Coupon.new( params[:coupon])
		@coupon.code.downcase!
		@coupon.discount = params[:coupon][:discount].to_f * 100
		@coupon.owner = @admin
		if params[:coupon][:expiration_date].blank? 
			@coupon.expiration_date = Time.now + 20.years 
		else
			@coupon.expiration_date = @coupon.expiration_date.end_of_day
		end

		if @coupon.save
			pop_flash 'Coupon was successfully created.'
		else
			pop_flash 'Oooops, coupon not saved...', :error, @coupon
		end
		redirect_to admin_author_coupons_path( @current_author )
		
	end
	
	
	def update
		@coupon = Coupon.find( params[:id] )
		@coupon.discount = params[:coupon][:discount].to_f * 100
		
		if params[:coupon][:expiration_date].blank? 
			@coupon.expiration_date = Time.now + 20.years 
		else
			@coupon.expiration_date = @coupon.expiration_date.end_of_day
		end	
		
		if @coupon.update_attributes( params[:coupon])
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
	
	def destroy
		@coupon = Coupon.find params[:id]
		@coupon.destroy
		pop_flash 'Coupon was successfully deleted.'
		redirect_to admin_author_coupons_path( @admin )
	end
	
private
	
	def get_owner
		@owner = @current_author ? @current_author : @author 
	end

	def get_admin
		@admin = @current_author ? @current_author : @current_site
		require_contributor if @admin == @current_site
	end

	def get_sidebar_data
		@upcoming_events = @owner.events.upcoming.published
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	
	def sort_column
		Coupon.column_names.include?( params[:sort] ) ? params[:sort] : 'code'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end

	def check_permissions
		unless @admin.has_valid_subscription?( Subscription.platform_builder )
			pop_flash "Update to the Author Platform Builder Account to access this feature!", :error
			redirect_to admin_index_path
		end
	end


end


