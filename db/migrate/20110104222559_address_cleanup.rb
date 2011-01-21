class AddressCleanup < ActiveRecord::Migration
	def self.up
		
		# Migrate addresses from old geo_addresses table
		create_table :tmp_geo_addresses, :force => true do |t|
			t.string		:address_type
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
													:user_id => order.user.id,
													:title => billing_address.title,
													:first_name => billing_address.first_name,
													:last_name => billing_address.last_name,
													:street => billing_address.street,
													:street2 => billing_address.street2,
													:city => billing_address.city,
													:geo_state_id => billing_address.geo_state.id,
													:zip => billing_address.zip,
													:country => billing_address.country,
													:phone => billing_address.phone,
													:address_type => 'billing' )
				new_geo_addy.save
				order.billing_address_id = new_geo_addy.id
				order.save
			end
	
			if order.shipping_address_id.present? #only merch orders have shipping addresses
				shipping_address = ShippingAddress.find( order.shipping_address_id)
				new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name_and_address_type(
													:user_id => order.user.id,
													:title => shipping_address.title,
													:first_name => shipping_address.first_name,
													:last_name => shipping_address.last_name,
													:street => shipping_address.street,
													:street2 => shipping_address.street2,
													:city => shipping_address.city,
													:geo_state_id => shipping_address.geo_state.id,
													:zip => shipping_address.zip,
													:country => shipping_address.country,
													:phone => shipping_address.phone,
													:address_type => 'shipping' ) 
				new_geo_addy.save
				order.shipping_address_id = new_geo_addy.id
				order.save
			end
		end

		billing_addresses = BillingAddress.all
			for billing_address in billing_addresses
				if billing_address.user.present?
						unless TmpGeoAddress.find_by_user_id_and_address_type(  billing_address.user.id, 'billing')
								new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(
													:user_id => billing_address.user.id,
													:title => billing_address.title,
													:first_name => billing_address.first_name,
													:last_name => billing_address.last_name,
													:street => billing_address.street,
													:street2 => billing_address.street2,
													:city => billing_address.city,
													:geo_state_id => billing_address.geo_state.id,
													:zip => billing_address.zip,
													:country => billing_address.country,
													:phone => billing_address.phone,
													:address_type => 'billing' )
								new_geo_addy.save
						end
				end
			end
		rename_column	:geo_addresses, :type, :address_type
		
		execute 'delete from geo_addresses'
		execute 'insert into geo_addresses (id, user_id, address_type, title, first_name, last_name, street, street2, city, geo_state_id, zip, country, phone) select id, user_id, address_type, title, first_name, last_name, street, street2, city, geo_state_id, zip, country, phone from tmp_geo_addresses'
		drop_table :tmp_geo_addresses

	end


	

	def self.down
		add_column :geo_addresses, :type, :string
		add_column :geo_addresses, :preferred, :boolean
		add_column :geo_addresses, :user_id, :integer
	end
end
