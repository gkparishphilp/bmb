# == Schema Information
# Schema version: 20110826004210
#
# Table name: redemptions
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  coupon_id  :integer(4)
#  order_id   :integer(4)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Redemption < ActiveRecord::Base
	belongs_to 	:coupon
	belongs_to 	:order
	belongs_to :user
	
	scope :dated_between, lambda { |*args| 
		where( "redemptions.created_at between ? and ?", (args.first.to_date || 7.days.ago.getutc), (args.second.to_date || Time.now.getutc) ) 
	}
	
	scope :for_author, lambda { |args|
		joins( "join coupons on coupons.id = coupon_id " ).where( "coupons.owner_type='Author' and coupons.owner_id = ?", args )
	}

	scope :redeemed, where( "status = 'redeemed'" )
		
end
