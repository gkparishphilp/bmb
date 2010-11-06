class Subscribing < ActiveRecord::Base
	belongs_to 	:subscription
	belongs_to 	:user
	belongs_to 	:order
	
	scope :active, where("status = 'ActiveProfile'")
	
	def cancel
		if !self.order and self.status == 'ActiveProfile'
			return true if self.update_attributes! :status => 'CancelledProfile' 
		elsif self.order and self.status == 'ActiveProfile'
			return true if self.order.cancel_paypal_subscription
		else
			return false
		end
		
	end

end


