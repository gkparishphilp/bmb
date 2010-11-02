class CouponsController < ApplicationController

	def giveaways
		@author = @current_user.author
	end

end