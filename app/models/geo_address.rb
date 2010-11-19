# == Schema Information
# Schema version: 20101110044151
#
# Table name: geo_addresses
#
#  id           :integer(4)      not null, primary key
#  type         :string(255)
#  user_id      :integer(4)
#  title        :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  street       :string(255)
#  street2      :string(255)
#  city         :string(255)
#  geo_state_id :integer(4)
#  zip          :string(255)
#  country      :string(255)
#  phone        :string(255)
#  preferred    :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#

class GeoAddress < ActiveRecord::Base
end
