class Stats < ActiveRecord::Migration
	def self.up
		
		create_table :backings, :force => true do |t|
			t.integer	:user_id
			t.integer	:book_id
			t.integer	:points,      :default => 0
			t.string	:description
			
			t.timestamps
		end
		
		create_table :backing_events, :force => true do |t|
			t.integer	:backing_id
			t.string	:event_type
			t.string	:url
			t.string	:ip
			t.integer	:points,     :default => 0
			
			t.timestamps
		end
		
		create_table :raw_backing_events, :force => true do |t|
			t.integer	:backing_id
		    t.integer	:backing_event_id
		    t.string	:event_type
		    t.string	:url
		    t.string	:ip
		    t.integer	:points,           :default => 0
			
			t.timestamps
		end
		
		create_table :stat_events, :force => true do |t|
			# we can roll rate-limited stat events into this table like backing_events do
			# that way, we can draw pretty graphs of views, downloads, etc over time
			t.string	:name
			t.integer	:statable_id
			t.string	:statable_type
			t.string	:ip
			t.integer	:count,         :default => 0
			t.string	:extra_data
			
			t.timestamps
		end
		
		create_table :raw_stat_events, :force => true do |t|
			t.string	:name
			t.integer	:statable_id
			t.string	:statable_type
			t.string	:ip
			t.integer	:count,         :default => 0
			t.string	:extra_data
			
			t.timestamps
		end
	end

	def self.down
		drop_table :backings
		drop_table :backing_events
		drop_table :raw_stats
		drop_table :raw_backing_events
	end
end
