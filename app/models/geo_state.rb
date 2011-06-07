# == Schema Information
# Schema version: 20110606205010
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
	has_one	:tax_rate
end
