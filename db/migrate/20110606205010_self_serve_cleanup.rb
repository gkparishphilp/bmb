class SelfServeCleanup < ActiveRecord::Migration
	def self.up
		add_column	:subscriptions, :name, :string
		add_column	:contracts, :title, :string
		
		create_table	:faqs do |t|
			t.references	:author
			t.string		:title
			t.text			:content
			t.integer		:listing_order
			t.string		:status, :default => 'publish'
			t.timestamps
		end
		
		add_index	:subscriptions, :name
		add_index	:faqs, [ :author_id, :listing_order ]
		
		add_index	:themes, :name
		
	end

	def self.down
		remove_column	:subscriptions, :name
		drop_table		:faqs
		remove_column :contracts, :title
		
	end
end
