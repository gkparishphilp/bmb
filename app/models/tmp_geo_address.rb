# == Schema Information
# Schema version: 20110318174450
#
# Table name: tmp_geo_addresses
#
#  id           :integer(4)      not null, primary key
#  address_type :string(255)
#  user_id      :integer(4)
#  title        :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  name         :string(255)
#  street       :string(255)
#  street2      :string(255)
#  city         :string(255)
#  state        :string(255)
#  zip          :string(255)
#  country      :string(255)
#  phone        :string(255)
#  preferred    :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class TmpGeoAddress < ActiveRecord::Base
	
	belongs_to	:geo_state
end
