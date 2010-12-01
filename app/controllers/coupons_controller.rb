class CouponsController < ApplicationController

	def giveaways
		@author = @current_user.author
	end
	
	def redeem
		@coupon = params[:coupon]
		@coupon.redeem
	end

	def sku_redemption
		@coupon = Coupon.find_by_code( params[:code] )
		@sku = Sku.find coupon.sku_id
	end

end


