class Polymorphs < ActiveRecord::Migration
	# Miscelaneous site objects like reviews, links, etc...
	def self.up
		
		create_table :links, :force => true do |t|
			t.integer	:owner_id
			t.string	:owner_type
			t.string	:title
			t.string	:url
			t.string	:description
			t.string	:link_type
			
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
		drop_table	:links
		dropt_table	:reviews
	end
end
