# == Schema Information
# Schema version: 20101120000321
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
	belongs_to :redeemer, :polymorphic => :true
end
