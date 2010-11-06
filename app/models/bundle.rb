class Bundle < ActiveRecord::Base
	has_many :coupons, :as => :redeemable
	has_many :orders, :as => :ordered
end