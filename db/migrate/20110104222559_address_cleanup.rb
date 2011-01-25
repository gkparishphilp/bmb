class AddressCleanup < ActiveRecord::Migration
	def self.up
		create_table :geo_countries do |t|
			t.string	:name
			t.string	:abbrev
			t.timestamps
		end
		
		add_column	:geo_addresses, :state, :string
		add_column	:geo_addresses, :name, :string
		
		GeoCountry.create :abbrev => "US", :name => "United States"
		GeoCountry.create :abbrev => "CA", :name => "Canada"
		GeoCountry.create :abbrev => "GB", :name => "United Kingdom"

		GeoCountry.create :abbrev => "AF", :name => "Afghanistan"
		GeoCountry.create :abbrev => "AL", :name => "Albania"
		GeoCountry.create :abbrev => "DZ", :name => "Algeria"
		GeoCountry.create :abbrev => "AS", :name => "American Samoa"
		GeoCountry.create :abbrev => "AD", :name => "Andorra"
		GeoCountry.create :abbrev => "AO", :name => "Angola"
		GeoCountry.create :abbrev => "AI", :name => "Anguilla"
		GeoCountry.create :abbrev => "AQ", :name => "Antarctica"
		GeoCountry.create :abbrev => "AG", :name => "Antigua and Barbuda"
		GeoCountry.create :abbrev => "AR", :name => "Argentina"
		GeoCountry.create :abbrev => "AM", :name => "Armenia"
		GeoCountry.create :abbrev => "AW", :name => "Aruba"
		GeoCountry.create :abbrev => "AU", :name => "Australia"
		GeoCountry.create :abbrev => "AT", :name => "Austria"
		GeoCountry.create :abbrev => "AZ", :name => "Azerbaidjan"
		GeoCountry.create :abbrev => "BS", :name => "Bahamas"
		GeoCountry.create :abbrev => "BH", :name => "Bahrain"
		GeoCountry.create :abbrev => "BD", :name => "Bangladesh"
		GeoCountry.create :abbrev => "BB", :name => "Barbados"
		GeoCountry.create :abbrev => "BY", :name => "Belarus"
		GeoCountry.create :abbrev => "BE", :name => "Belgium"
		GeoCountry.create :abbrev => "BZ", :name => "Belize"
		GeoCountry.create :abbrev => "BJ", :name => "Benin"
		GeoCountry.create :abbrev => "BM", :name => "Bermuda"
		GeoCountry.create :abbrev => "BT", :name => "Bhutan"
		GeoCountry.create :abbrev => "BO", :name => "Bolivia"
		GeoCountry.create :abbrev => "BA", :name => "Bosnia-Herzegovina"
		GeoCountry.create :abbrev => "BW", :name => "Botswana"
		GeoCountry.create :abbrev => "BV", :name => "Bouvet Island"
		GeoCountry.create :abbrev => "BR", :name => "Brazil"
		GeoCountry.create :abbrev => "IO", :name => "British Indian Ocean Territory"
		GeoCountry.create :abbrev => "BN", :name => "Brunei Darussalam"
		GeoCountry.create :abbrev => "BG", :name => "Bulgaria"
		GeoCountry.create :abbrev => "BF", :name => "Burkina Faso"
		GeoCountry.create :abbrev => "BI", :name => "Burundi"
		GeoCountry.create :abbrev => "KH", :name => "Cambodia"
		GeoCountry.create :abbrev => "CM", :name => "Cameroon"
		GeoCountry.create :abbrev => "CV", :name => "Cape Verde"
		GeoCountry.create :abbrev => "KY", :name => "Cayman Islands"
		GeoCountry.create :abbrev => "CF", :name => "Central African Republic"
		GeoCountry.create :abbrev => "TD", :name => "Chad"
		GeoCountry.create :abbrev => "CL", :name => "Chile"
		GeoCountry.create :abbrev => "CN", :name => "China"
		GeoCountry.create :abbrev => "CX", :name => "Christmas Island"
		GeoCountry.create :abbrev => "CC", :name => "Cocos (Keeling) Islands"
		GeoCountry.create :abbrev => "CO", :name => "Colombia"
		GeoCountry.create :abbrev => "KM", :name => "Comoros"
		GeoCountry.create :abbrev => "CG", :name => "Congo"
		GeoCountry.create :abbrev => "CK", :name => "Cook Islands"
		GeoCountry.create :abbrev => "CR", :name => "Costa Rica"
		GeoCountry.create :abbrev => "HR", :name => "Croatia"
		GeoCountry.create :abbrev => "CU", :name => "Cuba"
		GeoCountry.create :abbrev => "CY", :name => "Cyprus"
		GeoCountry.create :abbrev => "CZ", :name => "Czech Republic"
		GeoCountry.create :abbrev => "DK", :name => "Denmark"
		GeoCountry.create :abbrev => "DJ", :name => "Djibouti"
		GeoCountry.create :abbrev => "DM", :name => "Dominica"
		GeoCountry.create :abbrev => "DO", :name => "Dominican Republic"
		GeoCountry.create :abbrev => "TP", :name => "East Timor"
		GeoCountry.create :abbrev => "EC", :name => "Ecuador"
		GeoCountry.create :abbrev => "EG", :name => "Egypt"
		GeoCountry.create :abbrev => "SV", :name => "El Salvador"
		GeoCountry.create :abbrev => "GQ", :name => "Equatorial Guinea"
		GeoCountry.create :abbrev => "ER", :name => "Eritrea"
		GeoCountry.create :abbrev => "EE", :name => "Estonia"
		GeoCountry.create :abbrev => "ET", :name => "Ethiopia"
		GeoCountry.create :abbrev => "FK", :name => "Falkland Islands"
		GeoCountry.create :abbrev => "FO", :name => "Faroe Islands"
		GeoCountry.create :abbrev => "FJ", :name => "Fiji"
		GeoCountry.create :abbrev => "FI", :name => "Finland"
		GeoCountry.create :abbrev => "CS", :name => "Former Czechoslovakia"
		GeoCountry.create :abbrev => "SU", :name => "Former USSR"
		GeoCountry.create :abbrev => "FR", :name => "France"
		GeoCountry.create :abbrev => "FX", :name => "France (European Territory)"
		GeoCountry.create :abbrev => "GF", :name => "French Guyana"
		GeoCountry.create :abbrev => "TF", :name => "French Southern Territories"
		GeoCountry.create :abbrev => "GA", :name => "Gabon"
		GeoCountry.create :abbrev => "GM", :name => "Gambia"
		GeoCountry.create :abbrev => "GE", :name => "Georgia"
		GeoCountry.create :abbrev => "DE", :name => "Germany"
		GeoCountry.create :abbrev => "GH", :name => "Ghana"
		GeoCountry.create :abbrev => "GI", :name => "Gibraltar"
		GeoCountry.create :abbrev => "GB", :name => "Great Britain"
		GeoCountry.create :abbrev => "GR", :name => "Greece"
		GeoCountry.create :abbrev => "GL", :name => "Greenland"
		GeoCountry.create :abbrev => "GD", :name => "Grenada"
		GeoCountry.create :abbrev => "GP", :name => "Guadeloupe (French)"
		GeoCountry.create :abbrev => "GU", :name => "Guam (USA)"
		GeoCountry.create :abbrev => "GT", :name => "Guatemala"
		GeoCountry.create :abbrev => "GN", :name => "Guinea"
		GeoCountry.create :abbrev => "GW", :name => "Guinea Bissau"
		GeoCountry.create :abbrev => "GY", :name => "Guyana"
		GeoCountry.create :abbrev => "HT", :name => "Haiti"
		GeoCountry.create :abbrev => "HM", :name => "Heard and McDonald Islands"
		GeoCountry.create :abbrev => "HN", :name => "Honduras"
		GeoCountry.create :abbrev => "HK", :name => "Hong Kong"
		GeoCountry.create :abbrev => "HU", :name => "Hungary"
		GeoCountry.create :abbrev => "IS", :name => "Iceland"
		GeoCountry.create :abbrev => "IN", :name => "India"
		GeoCountry.create :abbrev => "ID", :name => "Indonesia"
		GeoCountry.create :abbrev => "INT", :name => "International"
		GeoCountry.create :abbrev => "IR", :name => "Iran"
		GeoCountry.create :abbrev => "IQ", :name => "Iraq"
		GeoCountry.create :abbrev => "IE", :name => "Ireland"
		GeoCountry.create :abbrev => "IL", :name => "Israel"
		GeoCountry.create :abbrev => "IT", :name => "Italy"
		GeoCountry.create :abbrev => "CI", :name => "Ivory Coast (Cote D&#39;Ivoire)"
		GeoCountry.create :abbrev => "JM", :name => "Jamaica"
		GeoCountry.create :abbrev => "JP", :name => "Japan"
		GeoCountry.create :abbrev => "JO", :name => "Jordan"
		GeoCountry.create :abbrev => "KZ", :name => "Kazakhstan"
		GeoCountry.create :abbrev => "KE", :name => "Kenya"
		GeoCountry.create :abbrev => "KI", :name => "Kiribati"
		GeoCountry.create :abbrev => "KW", :name => "Kuwait"
		GeoCountry.create :abbrev => "KG", :name => "Kyrgyzstan"
		GeoCountry.create :abbrev => "LA", :name => "Laos"
		GeoCountry.create :abbrev => "LV", :name => "Latvia"
		GeoCountry.create :abbrev => "LB", :name => "Lebanon"
		GeoCountry.create :abbrev => "LS", :name => "Lesotho"
		GeoCountry.create :abbrev => "LR", :name => "Liberia"
		GeoCountry.create :abbrev => "LY", :name => "Libya"
		GeoCountry.create :abbrev => "LI", :name => "Liechtenstein"
		GeoCountry.create :abbrev => "LT", :name => "Lithuania"
		GeoCountry.create :abbrev => "LU", :name => "Luxembourg"
		GeoCountry.create :abbrev => "MO", :name => "Macau"
		GeoCountry.create :abbrev => "MK", :name => "Macedonia"
		GeoCountry.create :abbrev => "MG", :name => "Madagascar"
		GeoCountry.create :abbrev => "MW", :name => "Malawi"
		GeoCountry.create :abbrev => "MY", :name => "Malaysia"
		GeoCountry.create :abbrev => "MV", :name => "Maldives"
		GeoCountry.create :abbrev => "ML", :name => "Mali"
		GeoCountry.create :abbrev => "MT", :name => "Malta"
		GeoCountry.create :abbrev => "MH", :name => "Marshall Islands"
		GeoCountry.create :abbrev => "MQ", :name => "Martinique (French)"
		GeoCountry.create :abbrev => "MR", :name => "Mauritania"
		GeoCountry.create :abbrev => "MU", :name => "Mauritius"
		GeoCountry.create :abbrev => "YT", :name => "Mayotte"
		GeoCountry.create :abbrev => "MX", :name => "Mexico"
		GeoCountry.create :abbrev => "FM", :name => "Micronesia"
		GeoCountry.create :abbrev => "MD", :name => "Moldavia"
		GeoCountry.create :abbrev => "MC", :name => "Monaco"
		GeoCountry.create :abbrev => "MN", :name => "Mongolia"
		GeoCountry.create :abbrev => "MS", :name => "Montserrat"
		GeoCountry.create :abbrev => "MA", :name => "Morocco"
		GeoCountry.create :abbrev => "MZ", :name => "Mozambique"
		GeoCountry.create :abbrev => "MM", :name => "Myanmar"
		GeoCountry.create :abbrev => "NA", :name => "Namibia"
		GeoCountry.create :abbrev => "NR", :name => "Nauru"
		GeoCountry.create :abbrev => "NP", :name => "Nepal"
		GeoCountry.create :abbrev => "NL", :name => "Netherlands"
		GeoCountry.create :abbrev => "AN", :name => "Netherlands Antilles"
		GeoCountry.create :abbrev => "NT", :name => "Neutral Zone"
		GeoCountry.create :abbrev => "NC", :name => "New Caledonia (French)"
		GeoCountry.create :abbrev => "NZ", :name => "New Zealand"
		GeoCountry.create :abbrev => "NI", :name => "Nicaragua"
		GeoCountry.create :abbrev => "NE", :name => "Niger"
		GeoCountry.create :abbrev => "NG", :name => "Nigeria"
		GeoCountry.create :abbrev => "NU", :name => "Niue"
		GeoCountry.create :abbrev => "NF", :name => "Norfolk Island"
		GeoCountry.create :abbrev => "KP", :name => "North Korea"
		GeoCountry.create :abbrev => "MP", :name => "Northern Mariana Islands"
		GeoCountry.create :abbrev => "NO", :name => "Norway"
		GeoCountry.create :abbrev => "OM", :name => "Oman"
		GeoCountry.create :abbrev => "PK", :name => "Pakistan"
		GeoCountry.create :abbrev => "PW", :name => "Palau"
		GeoCountry.create :abbrev => "PA", :name => "Panama"
		GeoCountry.create :abbrev => "PG", :name => "Papua New Guinea"
		GeoCountry.create :abbrev => "PY", :name => "Paraguay"
		GeoCountry.create :abbrev => "PE", :name => "Peru"
		GeoCountry.create :abbrev => "PH", :name => "Philippines"
		GeoCountry.create :abbrev => "PN", :name => "Pitcairn Island"
		GeoCountry.create :abbrev => "PL", :name => "Poland"
		GeoCountry.create :abbrev => "PF", :name => "Polynesia (French)"
		GeoCountry.create :abbrev => "PT", :name => "Portugal"
		GeoCountry.create :abbrev => "PR", :name => "Puerto Rico"
		GeoCountry.create :abbrev => "QA", :name => "Qatar"
		GeoCountry.create :abbrev => "RE", :name => "Reunion (French)"
		GeoCountry.create :abbrev => "RO", :name => "Romania"
		GeoCountry.create :abbrev => "RU", :name => "Russian Federation"
		GeoCountry.create :abbrev => "RW", :name => "Rwanda"
		GeoCountry.create :abbrev => "GS", :name => "S. Georgia & S. Sandwich Isls."
		GeoCountry.create :abbrev => "SH", :name => "Saint Helena"
		GeoCountry.create :abbrev => "KN", :name => "Saint Kitts & Nevis Anguilla"
		GeoCountry.create :abbrev => "LC", :name => "Saint Lucia"
		GeoCountry.create :abbrev => "PM", :name => "Saint Pierre and Miquelon"
		GeoCountry.create :abbrev => "ST", :name => "Saint Tome (Sao Tome) and Principe"
		GeoCountry.create :abbrev => "VC", :name => "Saint Vincent & Grenadines"
		GeoCountry.create :abbrev => "WS", :name => "Samoa"
		GeoCountry.create :abbrev => "SM", :name => "San Marino"
		GeoCountry.create :abbrev => "SA", :name => "Saudi Arabia"
		GeoCountry.create :abbrev => "SN", :name => "Senegal"
		GeoCountry.create :abbrev => "SC", :name => "Seychelles"
		GeoCountry.create :abbrev => "SL", :name => "Sierra Leone"
		GeoCountry.create :abbrev => "SG", :name => "Singapore"
		GeoCountry.create :abbrev => "SK", :name => "Slovak Republic"
		GeoCountry.create :abbrev => "SI", :name => "Slovenia"
		GeoCountry.create :abbrev => "SB", :name => "Solomon Islands"
		GeoCountry.create :abbrev => "SO", :name => "Somalia"
		GeoCountry.create :abbrev => "ZA", :name => "South Africa"
		GeoCountry.create :abbrev => "KR", :name => "South Korea"
		GeoCountry.create :abbrev => "ES", :name => "Spain"
		GeoCountry.create :abbrev => "LK", :name => "Sri Lanka"
		GeoCountry.create :abbrev => "SD", :name => "Sudan"
		GeoCountry.create :abbrev => "SR", :name => "Suriname"
		GeoCountry.create :abbrev => "SJ", :name => "Svalbard and Jan Mayen Islands"
		GeoCountry.create :abbrev => "SZ", :name => "Swaziland"
		GeoCountry.create :abbrev => "SE", :name => "Sweden"
		GeoCountry.create :abbrev => "CH", :name => "Switzerland"
		GeoCountry.create :abbrev => "SY", :name => "Syria"
		GeoCountry.create :abbrev => "TJ", :name => "Tadjikistan"
		GeoCountry.create :abbrev => "TW", :name => "Taiwan"
		GeoCountry.create :abbrev => "TZ", :name => "Tanzania"
		GeoCountry.create :abbrev => "TH", :name => "Thailand"
		GeoCountry.create :abbrev => "TG", :name => "Togo"
		GeoCountry.create :abbrev => "TK", :name => "Tokelau"
		GeoCountry.create :abbrev => "TO", :name => "Tonga"
		GeoCountry.create :abbrev => "TT", :name => "Trinidad and Tobago"
		GeoCountry.create :abbrev => "TN", :name => "Tunisia"
		GeoCountry.create :abbrev => "TR", :name => "Turkey"
		GeoCountry.create :abbrev => "TM", :name => "Turkmenistan"
		GeoCountry.create :abbrev => "TC", :name => "Turks and Caicos Islands"
		GeoCountry.create :abbrev => "TV", :name => "Tuvalu"
		GeoCountry.create :abbrev => "UG", :name => "Uganda"
		GeoCountry.create :abbrev => "UA", :name => "Ukraine"
		GeoCountry.create :abbrev => "AE", :name => "United Arab Emirates"

		GeoCountry.create :abbrev => "UY", :name => "Uruguay"
		GeoCountry.create :abbrev => "MIL", :name => "USA Military"
		GeoCountry.create :abbrev => "UM", :name => "USA Minor Outlying Islands"
		GeoCountry.create :abbrev => "UZ", :name => "Uzbekistan"
		GeoCountry.create :abbrev => "VU", :name => "Vanuatu"
		GeoCountry.create :abbrev => "VA", :name => "Vatican City State"
		GeoCountry.create :abbrev => "VE", :name => "Venezuela"
		GeoCountry.create :abbrev => "VN", :name => "Vietnam"
		GeoCountry.create :abbrev => "VG", :name => "Virgin Islands (British)"
		GeoCountry.create :abbrev => "VI", :name => "Virgin Islands (USA)"
		GeoCountry.create :abbrev => "WF", :name => "Wallis and Futuna Islands"
		GeoCountry.create :abbrev => "EH", :name => "Western Sahara"
		GeoCountry.create :abbrev => "YE", :name => "Yemen"
		GeoCountry.create :abbrev => "YU", :name => "Yugoslavia"
		GeoCountry.create :abbrev => "ZR", :name => "Zaire"
		GeoCountry.create :abbrev => "ZM", :name => "Zambia"
		GeoCountry.create :abbrev => "ZW", :name => "Zimbabwe"
		
		# TODO -- slam all this into one big mother address migration
		# Remember to set geo_address.state field == to the geo_state.abbrev
		
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
		
		remove_column	:geo_addresses, :geo_state_id
		remove_column	:geo_addresses, :first_name
		remove_column	:geo_addresses, :last_name
	end


	

	def self.down
		
	end
end
