class Forums < ActiveRecord::Migration
	def self.up
		create_table :forums, :force => true do |t|
			t.string   "name"
			t.integer  "owner_id"
			t.string   "owner_type"
			t.string   "availability"
			t.string   "description"
			t.string   "cached_slug"
			t.timestamps
		end
		
		create_table :posts, :force => true do |t|
			t.integer  "forum_id"
			t.integer  "topic_id"
			t.integer  "reply_to_post_id"
			t.integer  "user_id"
			t.string   "title"
			t.text     "content"
			t.integer  "view_count", :default => 0
			t.string   "ip"
			t.string   "type"
			t.string   "cached_slug"
			t.timestamps
		end
		
		add_index :forums, :owner_id
		add_index :forums, :cached_slug, :unique => true
		add_index :posts, :forum_id
		add_index :posts, :topic_id
		add_index :posts, :reply_to_post_id
		add_index :posts, :user_id
		add_index :posts, :cached_slug, :unique => true
		
	end

	def self.down
		drop_table	:forums
		drop_table	:posts
		
		remove_index :forums, :owner_id
		remove_index :forums, :cached_slug
		remove_index :posts, :user_id
		remove_index :posts, :reply_to_post_id
		remove_index :posts, :topic_id
		remove_index :posts, :forum_id
		remove_index :posts, :cached_slug
	end
end
