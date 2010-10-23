class Blog < ActiveRecord::Migration
	def self.up
		create_table :articles, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:title
			t.string	:excerpt
			t.integer	:snip_at
			t.integer	:view_count,	:default => 0
			t.text		:content
			t.string	:status
			t.boolean	:comments_allowed
			t.datetime	:publish_on
			t.string	:article_type
			t.string	:cached_slug
			t.timestamps
		end
		
		create_table :comments, :force => true do |t|
			t.integer	:user_id
			t.integer	:commentable_id
			t.string	:commentable_type
			t.integer	:reply_to_comment_id
			t.string	:name
			t.string	:email
			t.string	:website_name
			t.string	:website_url
			t.string	:ip
			t.text		:content
			t.timestamps
		end
		
		add_index :articles, :owner_id
		add_index :articles, :cached_slug, :unique => true
		add_index :comments, :user_id
		add_index :comments, :commentable_id
		add_index :comments, :reply_to_comment_id
		
	end

	def self.down
		drop_table	:articles
		drop_table	:comments
		
		remove_index :articles, :owner_id
		remove_index :articles, :cached_slug
		remove_index :comments, :reply_to_comment_id
		remove_index :comments, :commentable_id
		remove_index :comments, :user_id
		
		
	end
end
