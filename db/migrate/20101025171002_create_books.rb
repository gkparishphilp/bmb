class CreateBooks < ActiveRecord::Migration
	def self.up
		# Everything having to do with Books
		
		create_table :assets do |t|
			t.references	:book
			t.references	:content_location
			t.string		:title
			t.string		:format # pdf, mobi, epub, etc. even if in DB, may be txt, html, rtf, etc...
			t.integer		:price
			t.integer		:download_count, :default => 0
			t.string		:asset_type # full work, chapter, preview, etc...
			t.integer		:word_count
			t.string		:origin # uploaded, gernerated by Calibre, etc..
			t.string		:status # published or not

			t.timestamps
		end
		
		create_table :books do |t|
			t.references	:author
			t.references	:genre
			t.string		:title
			t.integer		:view_count, :default => 0
			t.integer		:score
			t.string		:subtitle
			t.text			:description
			t.string		:status
			t.string		:age_aprop
			t.float			:rating_average
			t.string		:backing_url # traffic cannon
			t.string		:cached_slug
			t.string		:cover_art_url
			t.string		:cover_art_file_name
		    t.string		:cover_art_content_type
		    t.integer		:cover_art_file_size
		    t.datetime		:cover_art_updated_at
			t.string		:status # published or not
			
			t.timestamps
		end
		
		#ISBNs, ASINs, etc.
		create_table :book_identifiers, :force => true do |t|
			t.references	:book_id
			t.string		:identifier_type
			t.string		:identifier
			t.string		:status
			
			t.timestamps
		end
		
		create_table :content_locations do |t|
			t.references	:asset
			t.string		:path
			t.text			:content

			t.timestamps
		end
		change_column :content_locations, :content, :longtext
		
		create_table :genres, :force => true do |t|
			t.references	:parent
			t.string		:name
			t.string		:description
			t.string		:cached_slug
			
			t.timestamps
		end
		
		create_table :readings, :force => true do |t|
			t.references	:book
			t.references	:user
			t.integer		:page_number
			t.string		:reading_type
			
			t.timestamps
		end
		
		
		create_table :upload_files, :force => true do |t|
			t.references	:user
			t.references	:book
			t.string		:title
			t.string		:ext
			t.string		:file_path
			t.string		:ip
			
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

