# == Schema Information
# Schema version: 20110826004210
#
# Table name: subscribings
#
#  id              :integer(4)      not null, primary key
#  subscription_id :integer(4)
#  user_id         :integer(4)
#  order_id        :integer(4)
#  status          :string(255)     default("active")
#  profile_id      :string(255)
#  expiration_date :datetime
#  origin          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  trial_end_date  :datetime
#

class Subscribing < ActiveRecord::Base
	belongs_to 	:subscription
	belongs_to 	:user
	belongs_to 	:order
	
	scope :active, where("status = 'ActiveProfile'")
	
	def cancel
		if !self.order and self.status == 'ActiveProfile'
			if self.update_attributes! :status => 'CancelledProfile' 
				UserMailer.cancel_subscription( self.order, self.user ).deliver
				return true 
			end
		elsif self.order and self.status == 'ActiveProfile'
			if self.order.cancel_paypal_subscription
				UserMailer.cancel_subscription( self.order, self.user ).deliver
				return true 
			end
		else
			return false
		end	
	end
	
	def active?
		self.status == 'ActiveProfile'
	end
	
	def trial?
		if self.trial_end_date.present? 
			self.trial_end_date > Time.now
		else
			return false
		end
	end
end


