# == Schema Information
# Schema version: 20110105172220
#
# Table name: coupons
#
#  id                  :integer(4)      not null, primary key
#  owner_id            :integer(4)
#  owner_type          :string(255)
#  sku_id              :integer(4)
#  user_id             :integer(4)
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
	belongs_to 	:sku
	belongs_to 	:user

	
	def is_valid?( sku )
		if self.already_redeemed?
			return false
		elsif ( self.expiration_date.present? and self.expiration_date < Time.now )
			return false
		elsif self.sku_id.present? and self.sku_id != sku.id
			return false
		else
			return true
		end
		
	end
	
	def generate_code
		random_string = rand(1000000000).to_s + Time.now.to_s
		self.code = Digest::SHA1.hexdigest random_string
		self.save
	end
	
	def redeem
		Redemption.create :user => self.user, :coupon_id => self.id, :status => 'redeemed'
	end
	
	def already_redeemed?
		self.redemptions.count > 0 ? num_redemptions = self.redemptions.find_all_by_status( 'redeemed' ).count : num_redemptions = 0
		if self.redemptions_allowed > 0
			num_redemptions < self.redemptions_allowed ? false : true
		elsif self.redemptions_allowed < 0
			return false
		else 
			return true  
		end
			 
	end
end
