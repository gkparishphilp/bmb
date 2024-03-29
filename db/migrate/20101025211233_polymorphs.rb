class Polymorphs < ActiveRecord::Migration
	# Miscelaneous site objects like reviews, links, etc...
	def self.up
		
		create_table :badges, :force => true do |t|
			t.string	:name
			t.string	:display_name
			t.string	:badge_type
			t.string	:description
			t.integer	:level
			t.string	:status, :default => 'publish'
			
			t.timestamps
		end
		
		create_table :badgings, :force => true do |t|
			t.references	:badge
			t.references	:badgeable, :polymorphic => true
			
			t.timestamps
		end
		
		create_table :contests, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:name
			t.text			:description
			t.datetime		:starts_at
			t.datetime		:ends_at
			
			t.timestamps
		end
		
		create_table :events, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:title
			t.text			:description
			t.datetime		:starts_at
			t.datetime		:ends_at
			t.string		:location
			t.string		:event_type
			t.string		:status, :default => 'publish'
			
			t.timestamps
		end
		
		create_table :links, :force => true do |t|
			t.references	:owner, :polymorphic => true
			t.string		:title
			t.string		:url
			t.string		:description
			t.string		:link_type
			t.string		:status, :default => 'publish'
			t.timestamps
		end
		
		create_table :messages, :force => true do |t|
			t.references	:to, :polymorphic => true
			t.references	:from, :polymorphic => true
			t.string		:from_type
			t.string		:title # subject
			t.text			:content
			t.datetime		:deliver_at
			t.string		:status, :default => 'publish'
			
			t.timestamps
		end
		
		create_table :reviews, :force => true do |t|
			t.references	:reviewable, :polymorphic => true
			t.references	:user
			t.integer		:score
			t.text			:content
			
			t.timestamps
		end
		
		add_index :badgings, :badge_id
		add_index :badgings, :badgeable_id
		add_index :contests, :owner_id
		add_index :events, :owner_id
		add_index :links, :owner_id
		add_index :messages, :to_id
		add_index :messages, :from_id
		add_index :reviews, :reviewable_id
		
	end

	def self.down
		drop_table :badges
		drop_table :badgings
		drop_table :events
		drop_table	:links
		drop_table :messages
		dropt_table	:reviews
	end
end
