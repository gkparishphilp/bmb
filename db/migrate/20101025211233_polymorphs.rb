class Polymorphs < ActiveRecord::Migration
	# Miscelaneous site objects like reviews, links, etc...
	def self.up
		
		create_table :badges, :force => true do |t|
			t.string	:name
			t.string	:display_name
			t.string	:badge_type
			t.string	:description
			t.integer	:level
			t.string	:artwork_file_name
			t.string	:artwork_content_type
			t.integer	:artwork_file_size
			t.datetime	:artwork_updated_at
			
			t.timestamps
		end
		
		create_table :badgings, :force => true do |t|
			t.integer	:badge_id
			t.integer	:badgeable_id
			t.string	:badgeable_type
			
			t.timestamps
		end
		
		create_table :links, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:title
			t.string	:url
			t.string	:description
			t.string	:link_type
			
			t.timestamps
		end
		
		create_table :messages, :force => true do |t|
			t.integer	:to_id
			t.string	:to_type
			t.integer	:from_id
			t.string	:from_type
			t.string	:subject
			t.text		:content
			t.datetime	:deliver_at
			t.string	:status
			
			t.timestamps
		end
		
		create_table :reviews, :force => true do |t|
			t.integer	:reviewable_id
			t.string	:reviewable_type
			t.integer	:user_id
			t.integer	:score
			t.text		:content
			
			t.timestamps
		end
		
	end

	def self.down
		drop_table :badgings
		drop_table :badges
		drop_table :messages
		drop_table	:links
		dropt_table	:reviews
	end
end
