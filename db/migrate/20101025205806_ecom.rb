class Ecom < ActiveRecord::Migration
	def self.up

		create_table :bundles, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string	:title
			t.text		:description
			t.integer	:price
			t.string	:artwork_url
			t.string	:artwork_file_name
		    t.string	:artwork_content_type
		    t.integer	:artwork_file_size
		    t.datetime	:artwork_updated_at
			
			t.timestamps
		end
		
		create_table :bundle_assets, :force => true do |t|
			t.references	:bundle
			t.references	:assets
			
			t.timestamps
		end
		
		create_table :coupons, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.references	:redeemable, :polymorphic => true # book, merch, subs
			t.references	:redeemer, :polymorphic => true
			t.string		:code # need to validate unique on code
			t.string		:description
			t.datetime		:expiration_date # nil = infinite
			t.integer		:redemptions_allowed, :default => -1 # neg numbers or nil = infinite
			t.string		:discount_type # cents, or percent
			t.integer		:discount
			
			t.timestamps
		end
		
		create_table :geo_addresses, :force => true do |t|
			t.string		:type	# For single table inheritance
			t.references	:user
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
		
		create_table :geo_states, :force => true do |t|
			t.string	:name
			t.string	:abbrev
			t.string	:country
			
			t.timestamps
		end
		
		create_table :merches, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:title
			t.text			:description
			t.integer		:inventory_count, :default => -1 # neg numbers of nil = infinite
			t.integer		:price
			t.string		:artwork_url
			t.string		:artwork_file_name
			t.string		:artwork_content_type
			t.integer		:artwork_file_size
			t.datetime		:artwork_updated_at
			t.string		:status # published or not
			
			t.timestamps
		end
		
		create_table :orders, :force => true do |t|
			t.references	:user
			t.references	:shipping_address
			t.references	:billing_address
			t.references	:ordered, :polymorphic => true
			t.string		:email
			t.string		:ip
			t.integer		:price
			t.string		:status
			t.string		:paypal_express_token
			t.string		:paypal_express_payer_id

			t.timestamps
		end
		
		create_table :order_transactions, :force => true do |t|
			t.references	:order
			t.integer		:price
			t.string		:message
			t.string		:reference
			t.string		:action
			t.text			:params
			t.boolean		:success
			t.boolean		:test
			
			t.timestamps
		end
		
		create_table :ownings, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.references	:owned, :polymorphic => true
			t.string	:status
			
			t.timestamps
		end
		
		create_table :redemptions, :force => true do |t|
			t.references	:redeemer, :polymorphic => true
			t.references	:coupon
			t.references	:order
			t.string		:status
			
			t.timestamps
		end
		
		create_table :royalties, :force => true do |t|
			t.references	:author
			t.references	:order
			t.integer		:amount
			t.boolean		:paid
			
			t.timestamps
			
		end
		
		create_table :subscribings, :force => true do |t|
			t.references	:subscription
			t.references	:user
			t.references	:order
			t.string		:status
			t.string		:profile_id # Paypal return value for subscription profile
			t.datetime		:expiration_date
			t.string		:origin
			t.timestamps
		end
		
		create_table :subscriptions, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:title
			t.string		:description
			t.string		:periodicity
			t.integer		:price
			t.integer		:monthly_email_limit
			t.integer		:redemptions_remaining, :default => -1
			t.integer		:subscription_length_in_days
			t.integer		:royalty_percentage
			
			t.timestamps
		end
		
	end

	def self.down
		drop_table :royalties
		drop_table :bundle_assets
		drop_table :bundles
		drop_table :redemptions
		drop_table :coupons
		drop_table :ownings
		drop_table :subscribings_users
		drop_table :subscribings
		drop_table :subscriptions
		drop_table :order_transactions
		drop_table :geo_addresses
		drop_table :geo_states
		drop_table :merch
		drop_table :orders
	end
end
