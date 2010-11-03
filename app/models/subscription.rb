class Subscription < ActiveRecord::Base
	# Subscriptions can NEVER be charged to Paypal at a price of zero or less.  Make a direct entry into the subscribings model if it is a free subscription.
	# Comped subscriptions should have the subscription_length_in_days value set, paid subscriptions should not have this set since Paypal uses periodicity	

	scope :active, where("status = 'ActiveProfile'")
end