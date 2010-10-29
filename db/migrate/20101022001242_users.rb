class Users < ActiveRecord::Migration
	def self.up
		create_table :fb_accounts, :force => true do |t|
			t.integer	:owner_id
			t.string 	:owner_type
			t.string	:email_hash
			t.string	:fb_name
			t.string	:fb_session_key
			t.string	:status
			t.timestamps
		end
		# These can't be added at table creation time
		add_column		:fb_accounts,	  :fb_user_id,	 :bigint,	:limit => 20
		
		create_table  :openids, :force => true	do |t|
			t.integer	:user_id
			t.string	:identifier
			t.string	:name
			t.string	:provider
			t.string	:status

			t.timestamps
		end

		create_table :roles, :force => true  do |t|
			t.string	:name
		end

		create_table :roles_users, :id => false, :force => true  do |t|
			t.belongs_to	:role
			t.belongs_to	:user
		end
		
		create_table :twitter_accounts, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:token
			t.string	:secret
			t.string	:twit_name
			t.string	:status
			t.timestamps
		end
		# These can't be added at table creation time
		add_column	 :twitter_accounts,	  :twit_id,	 :bigint,	:limit => 20
	 
		create_table :users, :force => true do |t|
			t.integer	:site_id
			t.string	:email
			t.string	:user_name
			t.integer	:score, :default => 0
			t.string	:website_name
			t.string	:website_url
			t.string	:hashed_password
			t.string	:salt
			t.string	:remember_token
			t.datetime	:remember_token_expires_at
			t.string	:activation_code
			t.datetime	:activated_at
			t.string	:status
			t.string	:cached_slug
			# Billing info
			t.integer	:name_changes, :default => 3
			t.string	:first_name
			t.string	:last_name
			t.string	:tax_id
		
			t.string	:orig_ip
			t.string	:last_ip
		
			# Photo stuff
			t.string	:photo_url
			t.string	:photo_file_name
			t.string	:photo_content_type
			t.integer	:photo_file_size
			t.datetime	:photo_updated_at

			# And PayPal
			t.string	:paypal_id, :limit => 13

			t.timestamps
		end
	 
		
	 
		# Need a boatload more indexes	****************
		add_index :openids, :user_id
		add_index :users, :user_name, :unique => true
		add_index :users, :email, :unique => true
		add_index :users, :activation_code
		add_index :users, :remember_token
		add_index :fb_accounts, :owner_id
		add_index :fb_accounts, :email_hash
		add_index :twitter_accounts, :owner_id
	end

	def self.down
	end
end
