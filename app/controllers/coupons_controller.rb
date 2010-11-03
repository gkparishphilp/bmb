class CouponsController < ApplicationController

	def giveaways
		@author = @current_user.author
	end
	
	def giveaway_redeem
		@coupon = Coupon.find_by_code( params[:code] )
		@redeemable = @freebie.redeemable
	end
	
	def redeem
		@coupon = params[:coupon]
		@coupon.redeem
	end
end