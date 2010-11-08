# == Schema Information
# Schema version: 20101103181324
#
# Table name: coupons
#
#  id                  :integer(4)      not null, primary key
#  owner_id            :integer(4)
#  owner_type          :string(255)
#  redeemable_id       :integer(4)
#  redeemable_type     :string(255)
#  redeemer_id         :integer(4)
#  redeemer_type       :string(255)
#  code                :string(255)
#  description         :string(255)
#  expiration_date     :datetime
#  redemptions_allowed :integer(4)      default(-1)
#  discount_type       :string(255)
#  discount            :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#

class Coupon < ActiveRecord::Base
	has_many	:redemptions
	has_many 	:orders, :through => :redemptions
	belongs_to 	:owner, :polymorphic => true
	belongs_to 	:redeemable, :polymorphic => true
	belongs_to 	:redeemer, :polymorphic => true

	
	def is_valid?(order)
		if self.redemptions_allowed == 0
			return false
		elsif (!self.expiration_date.nil? and self.expiration_date < Time.now)
			return false
		elsif !self.redeemable.blank? and self.redeemable.class != order.ordered.class
			return false
		elsif !self.redeemable.id.nil? and self.redeemable.id != order.ordered.id
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
		Redemptions.create! :redeemer => self.redeemer, :coupon_id => self.id, :status => 'redeemed'
	end
end
