class Redemption < ActiveRecord::Base
	belongs_to 	:coupon
	belongs_to 	:user
	belongs_to :redeemer, :polymorphic => :true
end