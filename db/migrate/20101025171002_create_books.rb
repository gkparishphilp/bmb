class CreateBooks < ActiveRecord::Migration
	def self.up
		# Everything having to do with Books
		
		create_table :assets do |t|
			t.integer	:book_id
			t.integer	:content_location_id
			t.string	:name
			t.string	:format # pdf, mobi, epub, etc. even if in DB, may be txt, html, rtf, etc...
			t.integer	:price
			t.integer	:download_count, :default => 0
			t.string	:asset_type # full work, chapter, preview, etc...
			t.integer	:word_count
			t.string	:origin # uploaded, gernerated by Calibre, etc..

			t.timestamps
		end
		
		# todo -- stub books model; flesh out
		create_table :books do |t|
			t.string	:title
			t.integer	:author_id
			t.integer	:genre_id
			t.integer	:view_count, :default => 0
			t.string	:subtitle
			t.text		:description
			t.string	:status
			t.string	:age_aprop
			t.float		:rating_average
			t.string	:backing_url # traffic cannon
			t.string	:cached_slug
			
			t.timestamps
		end
		
		#ISBNs, ASINs, etc.
		create_table :book_identifiers, :force => true do |t|
			t.integer	:book_id
			t.string	:identifier_type
			t.string	:identifier
			t.string	:status
			
			t.timestamps
		end
		
		create_table :content_locations do |t|
			t.integer	:asset_id
			t.string	:path
			t.text		:content

			t.timestamps
		end
		change_column :content_locations, :content, :longtext
		
		create_table :genres, :force => true do |t|
			t.integer	:parent_id
			t.string	:name
			t.string	:description
			t.string	:cached_slug
			
			t.timestamps
		end
		
		create_table :readings, :force => true do |t|
			t.integer	:book_id
			t.integer	:user_id
			t.integer	:page_number
			t.string	:reading_type
			
			t.timestamps
		end
		
		
		create_table :upload_files, :force => true do |t|
			t.integer	:user_id
			t.integer	:book_id
			t.string	:title
			t.string	:ext
			t.string	:file_path
			t.string	:ip
			
			t.timestamps
		end
		
	end

	def self.down
		
		drop_table :assets
		drop_table :books
		drop_table :book_identifiers
		drop_table :content_locations
		drop_table :genres
		drop_table :readings
		drop_table :upload_files
		
	end
end
