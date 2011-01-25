# == Schema Information
# Schema version: 20110104222559
#
# Table name: geo_addresses
#
#  id           :integer(4)      not null, primary key
#  address_type :string(255)
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
	
	belongs_to	:user
	
	# todo - clean these up and buff them out
	validates :name, :presence => true
	validates :street, :presence => true
	validates :city, :presence => true
	validates :zip, :presence => true
	validates :country, :presence => true
	
	validate :valid_geo_state
	
	# some cosmetic methods to display stuff
	
	def full_street
		street = ""
		street += self.street + " " unless self.street.blank?
		street +=self.street2 unless self.street2.blank?
		return street
	end
	
	def city_st_zip
		city_st_zip = ""
		city_st_zip +=  self.city + ", " unless self.city.blank?
		city_st_zip += self.state + " " unless self.state.blank?
		city_st_zip += self.zip + " " unless self.zip.blank?
		city_st_zip += self.country  unless self.country.blank?
		return city_st_zip
	end
	
	private
	
	def valid_geo_state
		if self.country == GeoCountry.usa.code
			geo_state = GeoState.find_by_abbrev( self.state ) || GeoState.find_by_name( self.state )
			if geo_state.nil? 
				self.errors.add :base, "#{self.state} is not a valid US State"
				return false
			end
			self.state = geo_state.abbrev # set field if we made it this far
		end
	end
	
end
