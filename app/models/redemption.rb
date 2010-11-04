class Redemption < ActiveRecord::Base
	belongs_to 	:coupon
	belongs_to 	:order
	belongs_to :redeemer, :polymorphic => :true
end