class AddressCleanup < ActiveRecord::Migration
	def self.up
		create_table :addressings, :force => true do |t|
			t.belongs_to	:owner, :polymorphic => true
			t.belongs_to	:geo_address
			t.string		:address_type
			t.boolean		:preferred
		end
		
		remove_column	:geo_addresses, :type
		remove_column	:geo_addresses, :preferred
		remove_column	:geo_addresses, :user_id
		
		
	end

	def self.down
		drop_table :addressings
		add_column :geo_addresses, :type, :string
		add_column :geo_addresses, :preferred, :boolean
		add_column :geo_addresses, :user_id, :integer
	end
end
