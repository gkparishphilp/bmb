class EmailCannon < ActiveRecord::Migration
	def self.up
		create_table :email_campaigns, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.references	:email_template # future use
			t.string		:title
			t.string		:status # Let's use a convention like "delivered@2010/10/30 14:22:00"
			t.string		:campaign_type # future use - scheduled or automated
			
			t.timestamps
		end
		
		create_table :email_messages, :force => true do |t|
			t.references	:email_campaign
			t.string		:subject
			t.text			:content
			t.datetime		:deliver_at
			t.string		:status # Let's use a convention like "delivered@2010/10/30 14:22:00"
			
			t.timestamps
		end
		
		create_table :email_subscribings, :force => true do |t|
			t.references	:subscribed_to, :polymorphic => true
			t.references	:subscriber, :polymorphic => true
			t.string		:status
			
			t.timestamps
		end
		
		create_table :email_deliveries, :force => true do |t|
			t.references	:email_subscribing
			t.references	:email_campaign
			t.string		:status # bounce, open, click-through etc.
			
			t.timestamps
		end
		
		create_table :upload_email_lists, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:file_name
			t.string		:file_path
			t.string		:list_type
			
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
