# == Schema Information
# Schema version: 20101103181324
#
# Table name: subscribings
#
#  id              :integer(4)      not null, primary key
#  subscription_id :integer(4)
#  user_id         :integer(4)
#  order_id        :integer(4)
#  status          :string(255)
#  profile_id      :string(255)
#  expiration_date :datetime
#  origin          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

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


