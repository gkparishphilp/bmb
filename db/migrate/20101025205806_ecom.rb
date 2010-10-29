class Ecom < ActiveRecord::Migration
	def self.up
		
		create_table :bundles, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:name
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
			t.integer	:bundle_id
			t.integer	:asset_id
			t.string	:asset_type
			
			t.timestamps
		end
		
		create_table :coupons, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type # site for global stuff or author to scope on suthor's specific stuff
			t.string	:code # need to validate unique on code
			t.string	:description
			t.datetime	:expiration_date # nil = infinite
			t.integer	:redemptions_allowed, :default => -1 # neg numbers or nil = infinite
			t.string	:discount_type # cents, or percent
			t.integer	:discount
			t.string	:valid_for_item_type # book, merch, subs
			t.integer	:valid_for_item_id # for giveaways?
			
			t.timestamps
		end
		
		create_table :geo_addresses, :force => true do |t|
			t.integer	:user_id
			t.string	:address_type # Billing, shipping, etc.
			t.string	:name
			t.string	:street
			t.string	:street2
			t.string	:city
			t.string	:geo_state_id
			t.string	:zip
			t.string	:phone
			
			t.timestamps
		end
		
		create_table :geo_states, :force => true do |t|
			t.string	:name
			t.string	:abbrev
			t.string	:country
			
			t.timestamps
		end
		
		create_table :merch, :force => true do |t|
			t.integer	:owner
			t.string	:owner_type
			t.string	:name
			t.integer	:inventory_count, :default => -1 # neg numbers of nil = infinite
			t.integer	:price
			t.string	:artwork_url
			t.string	:artwork_file_name
		    t.string	:artwork_content_type
		    t.integer	:artwork_file_size
		    t.datetime	:artwork_updated_at
			
			t.timestamps
		end
		
		create_table :orders, :force => true do |t|
			t.integer	:user_id
			t.string	:sku
			t.string	:email
			t.string	:ip
			t.integer	:price
			t.string	:status
			t.string	:paypal_express_token
			t.string	:paypal_express_payer_id
			
			t.timestamps
		end
		
		create_table :order_transactions, :force => true do |t|
			t.integer	:order_id
			t.integer	:price
			t.string	:message
			t.string	:reference
			t.string	:action
			t.text		:params
			t.boolean	:success
			t.boolean	:test
			
			t.timestamps
		end
		
		create_table :ownings, :force => true do |t|
			t.integer	:owned_id
			t.string	:owned_type
			t.integer	:user_id
			t.string	:status
			
			t.timestamps
		end
		
		create_table :redemptions, :force => true do |t|
			t.integer	:user_id
			t.integer	:coupon_id
			t.string	:status
			
			t.timestamps
		end
		
		create_table :royalties, :force => true do |t|
			t.integer	:author_id
			t.integer	:order_transaction_id
			t.boolean	:paid
			
			t.timestamps
			
		end
		
		create_table :subscribings, :force => true do |t|
			t.integer	:subscription_id
			t.integer	:user_id
			t.integer	:order_id
			t.string	:status
			t.string	:profile_id
			t.datetime	:expiration_date
			t.string	:origin
			
			t.timestamps
		end
		
		create_table :subscriptions, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:name
			t.string	:description
			t.string	:periodicity
			t.integer	:price
			t.integer	:monthly_email_limit
			t.integer	:redemptions_remaining
			t.integer	:subscription_length_in_days
			
			t.timestamps
		end
		
	end

	def self.down
		drop_table :royalties
		drop_table :bundle_assets
		drop_table :bundles
		drop_table :redemptioins
		drop_table :coupons
		drop_table :ownings
		drop_table :subscribings
		drop_table :subscriptions
		drop_table :order_transactions
		
		drop_table :geo_addresses
		drop_table :geo_states
		drop_table :merch
		
		drop_table :orders
	end
end
