class AddressCleanup < ActiveRecord::Migration
	def self.up
		
		rename_column	:geo_addresses, :type, :address_type
		
		# TODO - downcase type data for address_type field and remove duplicates
		# set orders to unduiped addresses
	end

	def self.down
		add_column :geo_addresses, :type, :string
		add_column :geo_addresses, :preferred, :boolean
		add_column :geo_addresses, :user_id, :integer
	end
end
