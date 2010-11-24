class CreateBooks < ActiveRecord::Migration
	def self.up
		# Everything having to do with Books
		
		create_table :assets do |t|
			t.references	:book
			t.string		:type # gonna try some STI
			t.string		:title
			t.text			:description
			t.integer		:download_count, :default => 0
			t.string		:asset_type # full work, chapter, preview, bonus, etc...
			t.string		:unlock_requirement # 'email' = email registerers, 'backer_xx' = for xx  points, etc.
			t.string		:content
			t.string		:duration # for audio
			t.string		:bitrate
			t.string		:resolution # in case of video
			t.integer		:word_count
			t.string		:origin # uploaded, gernerated by Calibre, etc..
			t.string		:status, :default => 'publish' # published or not

			t.timestamps
		end
		change_column :assets, :content, :longtext
		
		create_table :books do |t|
			t.references	:author
			t.references	:genre
			t.string		:title
			t.integer		:view_count, :default => 0
			t.integer		:score
			t.string		:subtitle
			t.text			:description
			t.string		:status, :default => 'publish'
			t.string		:age_aprop
			t.float			:rating_average
			t.string		:backing_url # traffic cannon
			t.string		:cached_slug
			t.string		:status, :default => 'publish' # published or not
			
			t.timestamps
		end
		
		#ISBNs, ASINs, etc.
		create_table :book_identifiers, :force => true do |t|
			t.references	:book
			t.string		:identifier_type
			t.string		:identifier
			t.string		:status
			
			t.timestamps
		end
		
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
		
		
	end

	def self.down
		
		drop_table :assets
		drop_table :books
		drop_table :book_identifiers
		drop_table :content_locations
		drop_table :genres
		drop_table :readings
		
	end
end

