class CreateAuthors < ActiveRecord::Migration
	def self.up
		# todo -- stub authors model; flesh out
		create_table :authors do |t|
			t.integer	:user_id
			t.integer	:featured_book_id
			t.string	:pen_name
			t.text		:bio
			t.integer	:score
			t.string	:cached_slug
			t.string	:photo_file_name
		    t.string	:photo_content_type
		    t.integer	:photo_file_size
		    t.datetime	:photo_updated_at
		    t.string	:photo_url

			t.timestamps
		end
		
		create_table :themes, :force => true do |t|
			t.integer	:author_id
			t.string	:bg_color
			t.string	:text_color
			t.string	:link_color
			t.string	:bg_img_file_name
		    t.string	:bg_img_content_type
		    t.integer	:bg_img_file_size
		    t.datetime	:bg_img_updated_at
		    t.string	:bg_repeat
		    t.string	:bg_img_url
		    t.string	:banner_img_file_name
		    t.string	:banner_img_content_type
		    t.integer	:banner_img_file_size
		    t.datetime	:banner_img_updated_at
		    t.string	:banner_img_url
			
			t.timestamps
		end
		
	end

	def self.down
		drop_table :themes
		drop_table :authors
	end
end
