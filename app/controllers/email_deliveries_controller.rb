class EmailDeliveriesController < ApplicationController

	def process_open
		@email_delivery = EmailDelivery.find_by_code( params[:code] )
		@email_delivery.update_attributes :status => 'opened'
		send_file "#{Rails.root}/public/images/pixel.png", :type  => 'image/png', :disposition => 'inline'
	end

end
