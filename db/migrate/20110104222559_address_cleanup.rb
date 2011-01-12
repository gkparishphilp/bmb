class AddressCleanup < ActiveRecord::Migration
	def self.up
		create_table :addressings, :force => true do |t|
			t.belongs_to	:owner, :polymorphic => true
			t.belongs_to	:geo_address
			t.string		:address_type
			t.boolean		:preferred
		end
		
		create_table :tmp_geo_addresses, :force => true do |t|
			t.string		:title
			t.string		:first_name
			t.string		:last_name
			t.string		:street
			t.string		:street2
			t.string		:city
			t.references	:geo_state
			t.string		:zip
			t.string		:country
			t.string		:phone
			t.timestamps
		end

		# Need these columns to be available for data migration.  Delete AFTER data migration has occurred.
		#remove_column	:geo_addresses, :type
		#remove_column	:geo_addresses, :preferred
		#remove_column	:geo_addresses, :user_id
		
	end

	def self.down
		drop_table :addressings
		add_column :geo_addresses, :type, :string
		add_column :geo_addresses, :preferred, :boolean
		add_column :geo_addresses, :user_id, :integer
	end
end
