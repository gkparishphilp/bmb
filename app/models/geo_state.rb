# == Schema Information
# Schema version: 20101120000321
#
# Table name: geo_states
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  country    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class GeoState < ActiveRecord::Base
	has_many :shipping_addresses
	has_many :billing_address
end
