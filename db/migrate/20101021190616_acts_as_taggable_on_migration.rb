class ActsAsTaggableOnMigration < ActiveRecord::Migration
	def self.up
		create_table :tags, :force => true do |t|
			t.string	:name
		end

		create_table :taggings, :force => true do |t|
			t.references	:tag
			t.references	:taggable, :polymorphic => true
			t.references	:tagger, :polymorphic => true
			t.string		:context
			t.datetime		:created_at
		end

		add_index :taggings, :tag_id
		add_index :taggings, [:taggable_id, :taggable_type, :context]
	end

	def self.down
		drop_table :taggings
		drop_table :tags
	end
end
