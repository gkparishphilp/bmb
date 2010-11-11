# == Schema Information
# Schema version: 20101110044151
#
# Table name: subscriptions
#
#  id                          :integer(4)      not null, primary key
#  owner_id                    :integer(4)
#  owner_type                  :string(255)
#  title                       :string(255)
#  description                 :string(255)
#  periodicity                 :string(255)
#  price                       :integer(4)
#  monthly_email_limit         :integer(4)
#  redemptions_remaining       :integer(4)      default(-1)
#  subscription_length_in_days :integer(4)
#  royalty_percentage          :integer(4)
#  created_at                  :datetime
#  updated_at                  :datetime
#

class Subscription < ActiveRecord::Base
	# Subscriptions can NEVER be charged to Paypal at a price of zero or less.  Make a direct entry into the subscribings model if it is a free subscription.
	# Comped subscriptions should have the subscription_length_in_days value set, paid subscriptions should not have this set since Paypal uses periodicity	


end
