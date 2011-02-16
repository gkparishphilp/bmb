class EmailDeliveriesController < ApplicationController

	def count_open
		@email_delivery = EmailDelivery.find_by_code( params[:code] )
		@email_delivery.update_attributes :status => 'opened'

		send_file "#{Rails.root}/public/images/badge.png", :type  => 'image/png', :disposition => 'inline'
	end
end
