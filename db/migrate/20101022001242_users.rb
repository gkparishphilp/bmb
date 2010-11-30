class Users < ActiveRecord::Migration
	def self.up
		create_table :facebook_accounts, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:name
			t.string		:fb_id
			t.string		:fb_token
			t.string		:status
		
			t.timestamps
		end
		
		create_table :facebook_pages, :force => true do |t|
			t.references	:facebook_account
			t.string		:name
			t.string		:page_type # page or group
			t.string		:fb_id
			t.string		:status, :default => 'active'
			
			t.timestamps
		end
		
		create_table  :openids, :force => true	do |t|
			t.references	:user
			t.string		:identifier
			t.string		:name
			t.string		:provider
			t.string		:status, :default => 'active'

			t.timestamps
		end
	
		create_table :roles, :force => true  do |t|
			t.references	:user
			t.references	:site
			t.string	:role
			
			t.timestamps
		end
		
		create_table :twitter_accounts, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:twit_id
			t.string		:token
			t.string		:secret
			t.string		:name
			t.string		:status, :default => 'active'
			
			t.timestamps
		end
	 
		create_table :users, :force => true do |t|
			t.references	:site
			t.string		:email
			t.string		:name
			t.integer		:score, :default => 0
			t.string		:website_name
			t.string		:website_url
			t.text			:bio
			t.string		:hashed_password
			t.string		:salt
			t.string		:remember_token
			t.datetime		:remember_token_expires_at
			t.string		:activation_code
			t.datetime		:activated_at
			t.string		:status, :default => 'first'
			t.string		:cached_slug

			# Billing info
			t.integer		:name_changes, :default => 3
			t.string		:tax_id
		
			t.string		:orig_ip
			t.string		:last_ip

			# And PayPal
			t.string		:paypal_id, :limit => 13

			t.timestamps
		end
	 
		
	 
		# Need a boatload more indexes	****************
		add_index :openids, :user_id
		add_index :users, :name
		add_index :users, :email, :unique => true
		add_index :users, :activation_code
		add_index :users, :remember_token
		add_index :facebook_accounts, :owner_id
		add_index :facebook_pages, :facebook_account_id
		add_index :twitter_accounts, :owner_id
	end

	def self.down
		drop_table	:facebook_accounts
		drop_table	:facebook_pages
		drop_table	:openids
		drop_table	:roles
		drop_table	:twitter_accounts
		drop_table	:users
	end
end
