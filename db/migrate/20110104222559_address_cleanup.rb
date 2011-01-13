class AddressCleanup < ActiveRecord::Migration
	def self.up
		create_table :addressings, :force => true do |t|
			t.belongs_to	:owner, :polymorphic => true
			t.belongs_to	:geo_address
			t.string		:address_type
			t.boolean		:preferred
		end
		
		create_table :tmp_geo_addresses, :force => true do |t|
			t.string		:type	# For single table inheritance
			t.references	:user
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
			t.boolean		:preferred, :default => 0
			t.timestamps
		end

		# Migration for new address scheme
		orders = Order.all
		for order in orders
			if order.billing_address_id.present?  #CC orders only have billing address, not Paypal
				billing_address = BillingAddress.find( order.billing_address_id )
				new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(	
				 															:title => billing_address.title,
																			:first_name => billing_address.first_name,
																			:last_name => billing_address.last_name,
																			:street => billing_address.street,
																			:street2 => billing_address.street2,
																			:city => billing_address.city,
																			:geo_state_id => billing_address.geo_state.id,
																			:zip => billing_address.zip,
																			:country => billing_address.country,
																			:phone => billing_address.phone )
				new_geo_addy.save
				Addressing.create :owner_id => order.id, :owner_type => 'Order', :geo_address_id => new_geo_addy.id, :address_type => 'billing'
			end

			if order.shipping_address_id.present? #only merch orders have shipping addresses
				shipping_address = ShippingAddress.find( order.shipping_address_id)
				new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(
				 															:title => shipping_address.title,
																			:first_name => shipping_address.first_name,
																			:last_name => shipping_address.last_name,
																			:street => shipping_address.street,
																			:street2 => shipping_address.street2,
																			:city => shipping_address.city,
																			:geo_state_id => shipping_address.geo_state.id,
																			:zip => shipping_address.zip,
																			:country => shipping_address.country,
																			:phone => shipping_address.phone ) 
				new_geo_addy.save
				Addressing.create :owner_id => order.id, :owner_type => 'Order', :geo_address_id => new_geo_addy.id, :address_type => 'shipping'
			end
		end

		billing_addresses = BillingAddress.all
		for billing_address in billing_addresses
			if billing_address.user.present?
				unless Addressing.find_by_owner_id_and_owner_type_and_address_type(  billing_address.user.id, 'User', 'billing')
					new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(	
					 															:title => billing_address.title,
																				:first_name => billing_address.first_name,
																				:last_name => billing_address.last_name,
																				:street => billing_address.street,
																				:street2 => billing_address.street2,
																				:city => billing_address.city,
																				:geo_state_id => billing_address.geo_state.id,
																				:zip => billing_address.zip,
																				:country => billing_address.country,
																				:phone => billing_address.phone )
					new_geo_addy.save
					Addressing.create :owner_id => billing_address.user.id, :owner_type => 'User', :geo_address_id => new_geo_addy.id, :address_type => 'billing'
				end
			end
		end
		
		execute 'delete from geo_addresses'
		execute 'insert into geo_addresses (id, title, first_name, last_name, street, street2, city, geo_state_id, zip, country, phone) select id, title, first_name, last_name, street, street2, city, geo_state_id, zip, country, phone from tmp_geo_addresses'
		execute 'drop table tmp_geo_addresses'

		# Need these columns to be available for data migration.  Delete AFTER data migration has occurred.
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
