class CreateAuthors < ActiveRecord::Migration
	def self.up
		# todo -- stub authors model; flesh out
		create_table :authors do |t|
			t.references	:user
			t.references	:featured_book
			t.string		:pen_name
			t.string		:subdomain
			t.string		:domain
			t.text			:bio
			t.integer		:score
			t.string		:cached_slug
			t.string		:photo_file_name
		    t.string		:photo_content_type
		    t.integer		:photo_file_size
		    t.datetime		:photo_updated_at
		    t.string		:photo_url

			t.timestamps
		end
		
		create_table :themes, :force => true do |t|
			t.references	:author
			t.string		:name
			t.string		:status
			t.string		:bg_color
			t.string		:text_color
			t.string		:link_color
			t.string		:color1
			t.string		:color2
			t.string		:color3
			t.string		:color4
		    t.string		:bg_repeat
			
			t.timestamps
		end
		
	end

	def self.down
		drop_table :themes
		drop_table :authors
	end
end
