# == Schema Information
# Schema version: 20110602231354
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
	
	def self.usa
		return GeoCountry.find( 1 )
	end
	
	def code
		return self.abbrev.upcase
	end
end
