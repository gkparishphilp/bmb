# == Schema Information
# Schema version: 20101120000321
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
	
	def full_name
		name = ""
		name += self.title + " " unless self.title.blank?
		name += self.first_name + " " + self.last_name
		return name
	end
	
	def full_street
		street = ""
		street += self.street + " " unless self.street.blank?
		street +=self.street2 unless self.street2.blank?
		return street
	end
	
	def city_st_zip
		city_st_zip = ""
		city_st_zip +=  self.city + ", " unless self.city.blank?
		city_st_zip += self.geo_state.abbrev + " " unless self.geo_state.abbrev.blank?
		city_st_zip += self.zip + " " unless self.zip.blank?
		city_st_zip += self.country  unless self.country.blank?
		return city_st_zip
	end
end
