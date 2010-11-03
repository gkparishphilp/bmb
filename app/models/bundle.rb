class Bundle < ActiveRecord::Base
	has_many :coupons, :as => :redeemable
end