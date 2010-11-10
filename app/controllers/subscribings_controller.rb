class SubscribingsController < ApplicationController

	def cancel
		@subscribing = Subscribing.find params[:id]
		if @subscribing.cancel
			pop_flash 'Subscription successfully cancelled', 'success'
		else
			pop_flash 'Subscription not cancelled', 'error', @subscribing
		end
		
		redirect_to admin_authors_path
	end
	
end