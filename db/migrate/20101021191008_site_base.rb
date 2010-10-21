class SiteBase < ActiveRecord::Migration
	# THis migration sets up the basic components of the website: site object, contacts, crashes, stats, etc...
	def self.up
		
		create_table :contacts, :force => true do |t|
			t.string   "email"
			t.string   "subject"
			t.string   "ip"
			t.integer  "crash_id"
			t.text     "content"
			t.timestamps
		end
		
		create_table :crashes, :force => true do |t|
			t.string   "message"
			t.string   "requested_url"
			t.string   "referrer"
			t.text     "backtrace"
			t.timestamps
		end
		
		create_table :links, :force => true do |t|
			t.integer  "owner_id"
			t.string   "owner_type"
			t.string   "title"
			t.string   "url"
			t.string   "description"
			t.string   "link_type"
			t.timestamps
		end
		
		create_table :raw_stats, :force => true do |t|
			t.string   "name"
			t.integer  "statable_id"
			t.string   "statable_type"
			t.string   "ip"
			t.integer  "count",         :default => 0
			t.string   "extra_data"
			t.timestamps
		end
		
		create_table :sites do |t|
			t.string  "name"
			t.integer "owner_id"
			t.string  "owner_type"
			t.timestamps
		end
		
		create_table :static_pages, :force => true do |t|
			t.integer  "site_id"
			t.string   "title"
			t.string   "description"
			t.string   "permalink"
			t.text     "content"
			t.timestamps
		end
		
		add_index :contacts, :email
		add_index :contacts, :crash_id
		add_index :links, :owner_id
		add_index :raw_stats, :statable_id
		add_index :sites, :owner_id
		add_index :static_pages, :site_id
		add_index :static_pages, :permalink
		
	end

	def self.down
		
		drop_table	:contacts
		drop_table	:crashes
		drop_table	:links
		drop_table	:raw_stats
		drop_table	:sites
		drop_table	:static_pages
		
		remove_index :contacts, :crash_id
		remove_index :contacts, :email
		remove_index :static_pages, :permalink
		remove_index :raw_stats, :statable_id
		remove_index :links, :owner_id
		remove_index :sites, :owner_id
		remove_index :static_pages, :site_id

	end
end
