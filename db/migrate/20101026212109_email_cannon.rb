class EmailCannon < ActiveRecord::Migration
	def self.up
		create_table :email_campaigns, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.integer	:email_template_id # future use
			t.string	:name
			t.string	:status # Let's use a convention like "delivered@2010/10/30 14:22:00"
			t.string	:campaign_type # future use - scheduled or automated
			
			t.timestamps
		end
		
		create_table :email_messages, :force => true do |t|
			t.integer	:email_campaign_id
			t.string	:subject
			t.text		:content
			t.datetime	:deliver_at
			t.string	:status # Let's use a convention like "delivered@2010/10/30 14:22:00"
			
			t.timestamps
		end
		
		create_table :email_subscribings, :force => true do |t|
			t.integer	:subscribed_to_id  
			t.string	:subscribed_to_type
			t.integer	:subscriber_id
			t.integer	:subscriber_type
			t.string	:email_address
			t.string	:name
			t.string	:status
			
			t.timestamps
		end
		
		create_table :email_deliveries, :force => true do |t|
			t.integer	:email_subscribing
			t.integer	:campaign_id
			t.string	:status # bounce, open, click-through etc.
			
			t.timestamps
		end
		
		create_table :upload_email_lists, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:file_name
			t.string	:file_path
			t.string	:list_type
			t.timestamps
		end
		
		
	end

	def self.down
		drop_table :upload_email_lists
		drop_table :email_deliveries
		drop_table :email_subscribings
		drop_table :email_campaigns
	end
end
