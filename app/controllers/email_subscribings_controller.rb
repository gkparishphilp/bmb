class EmailSubscribingsController < ApplicationController

	def unsubscribe
		if params[:code]
			if subscription = EmailSubscribing.find_by_unsubscribe_code( params[:code] )
				subscription.update_attributes :status => 'unsubscribed'
				pop_flash 'You have been unsubscribed.', 'success'
			else
				pop_flash 'Invalid unsubscribe code', 'error'
			end
			redirect_to root_path
		else
			# TODO Logic for unsubscribing when a BmB user is subscribed to an author
		end
	end
	
end

