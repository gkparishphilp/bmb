class CreateGeoCountries < ActiveRecord::Migration
	def self.up
		
		
		
	end

	def self.down
		drop_table :geo_countries
		remove_column	:geo_adresses, :state
	end
end
