class Ecom < ActiveRecord::Migration
	def self.up
		
		create_table :coupons, :force => true do |t|
			t.references	:owner, :polymorphic => true  # the author, or us
			t.references	:sku
			t.references	:user
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
			t.integer		:inventory_count, :default => -1 # neg numbers or nil = infinite
			t.string		:status, :default => 'publish' # published or not
			
			t.timestamps
		end
		
		create_table :orders, :force => true do |t|
			t.references	:user
			t.references	:shipping_address
			t.references	:billing_address
			t.references	:sku
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
			t.references	:user
			t.references	:sku
			t.string	:status, :default => 'active'
			t.boolean	:delivered, :default => 0
			
			t.timestamps
		end
		
		create_table :redemptions, :force => true do |t|
			t.references	:user
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
		
		create_table :skus, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.references	:book
			t.string		:title
			t.text			:description
			t.integer		:price
			t.string		:sku_type # just so we can unique the ebook sku accross the different asset formats
			t.string		:status, :default => 'publish'
			
			t.timestamps
		end
		
		create_table :sku_items, :id => false, :force => true do |t|
			t.references	:sku
			t.references	:item, :polymorphic => true
			
			t.timestamps
		end
		
		create_table :subscribings, :force => true do |t|
			t.references	:subscription
			t.references	:user
			t.references	:order
			t.string		:status, :default => 'active'
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
			t.string		:status, :default => 'publish'
			
			t.timestamps
		end
		
		add_index :coupons, :owner_id
		add_index :coupons, :user_id
		add_index :coupons, :sku_id
		add_index :coupons, :code
		add_index :geo_addresses, :user_id
		add_index :geo_addresses, :geo_state_id
		add_index :merches, :owner_id
		add_index :orders, :user_id
		add_index :orders, :sku_id
		add_index :order_transactions, :order_id
		add_index :ownings, :user_id
		add_index :ownings, :sku_id
		add_index :redemptions, :user_id
		add_index :redemptions, :coupon_id
		add_index :redemptions, :order_id
		add_index :royalties, :author_id
		add_index :royalties, :order_id
		add_index :skus, :owner_id
		add_index :skus, :book_id
		add_index :sku_items, :sku_id
		add_index :sku_items, :item_id
		add_index :subscribings, :subscription_id
		add_index :subscribings, :user_id
		add_index :subscribings, :order_id
		add_index :subscriptions, :owner_id
		
		
	end

	def self.down
		drop_table :royalties
		drop_table :sku_assets
		drop_table :skus
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
