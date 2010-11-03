class Coupon < ActiveRecord::Base
	belongs_to 	:order
	belongs_to 	:owner, :polymorphic => true
	belongs_to 	:redeemable, :polymorphic => true
	belongs_to 	:redeemer, :polymorphic => true
	has_many 	:redemptions
	
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
	
	def generate_giveaway_code
		random_string = rand(1000000000).to_s + Time.now.to_s
		self.code = Digest::SHA1.hexdigest random_string
		self.save
	end
	
	def redeem
		Redemptions.find_or_create!(:user_id => )
	end
end