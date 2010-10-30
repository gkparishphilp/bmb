class Coupon < ActiveRecord::Base
	belongs_to :order
	
	def is_valid?

		if self.redemptions_allowed == 0
			return false
		elsif (!self.expiration_date.nil? and self.expiration_date < Time.now)
			return false
		elsif !self.valid_for_item_type.blank? and self.valid_for_item_type != self.order.ordered.type.to_s
			return false
		elsif !self.valid_for_item_id.blank? and self.valid_for_item_id != self.order.ordered.id
			return false
		else
			return true
		end
		
	end
end