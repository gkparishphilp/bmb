class CreateAuthors < ActiveRecord::Migration
	def self.up
		# todo -- stub authors model; flesh out
		create_table :authors do |t|
			t.references	:user
			t.references	:featured_book
			t.string		:pen_name
			t.text			:promo
			t.string		:subdomain
			t.text			:bio
			t.integer		:score
			t.string		:cached_slug
			t.timestamps
		end
		
		create_table :themes, :force => true do |t|
			t.references	:creator # now, the creator
			t.string		:name
			t.string		:status, :default => 'active'
			t.boolean		:show_pen_name, :default => true
			t.string		:bg_color
			t.string		:bg_repeat
			t.string		:banner_bg_color, :default => "#ffffff"
			t.string		:banner_repeat
			t.string		:header_color
			t.string		:content_bg_color, :default => "#ffffff"
			t.string		:title_color
			t.string		:text_color
			t.string		:link_color
			t.string		:hover_color
			t.boolean		:book_site, :default => false
			t.boolean		:public, :default => false

			t.timestamps
		end
		
		create_table :theme_ownings, :force => true do |t|
			t.references	:author
			t.references	:theme
			t.boolean		:active, :default => false
			
			t.timestamps
		end
		
		add_index :authors, :user_id
		add_index :authors, :pen_name
		add_index :authors, :subdomain
		add_index :themes, :creator
		add_index :theme_ownings, :author_id
		add_index :theme_ownings, :theme_id
		
	end

	def self.down
		drop_table :themes
		drop_table :authors
	end
end
