class SubscribingsController < ApplicationController

	def cancel
		@subscribing = Subscribing.find params[:id]
		if @subscribing.cancel
			pop_flash 'Subscription successfully cancelled', 'success'
		else
			pop_flash 'Subscription not cancelled', 'error', @subscribing
		end
		
		redirect_to edit_author_path
	end
	
end