class CouponsController < ApplicationController

	def giveaways
		@author = @current_user.author
	end
	
	def freebie_redeem
		@freebie = Coupon.find_by_giveaway_code( params[:code] )
		@redeemable = @freebie.redeemable
	end
end