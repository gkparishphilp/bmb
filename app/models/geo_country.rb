# == Schema Information
# Schema version: 20110121210536
#
# Table name: geo_countries
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class GeoCountry < ActiveRecord::Base
	
	has_many	:geo_addresses
	
	def self.usa
		return GeoCountry.find( 1 )
	end
	
	def code
		return self.abbrev.upcase
	end
end
