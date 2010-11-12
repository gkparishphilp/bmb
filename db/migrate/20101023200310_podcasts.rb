class Podcasts < ActiveRecord::Migration
	def self.up
		create_table :podcasts do |t|
			t.references	:owner, :polymoprhic => true
			t.string		:title
			t.string		:subtitle
			t.string		:itunes_id
			t.text			:description
			t.string		:duration
			t.string		:filename
			t.string		:keywords
			t.integer		:filesize
			t.string		:explicit
			t.string		:status
			t.string		:cached_slug

			t.timestamps
		end
		
		create_table :episodes do |t|
			t.references	:podcast
			t.string		:title
			t.string		:subtitle
			t.string		:keywords
			t.string		:duration
			t.text			:description
			t.string		:explicit
			t.text			:transcript
			t.string		:status
			t.string		:cached_slug

			t.timestamps
		end

		add_index :podcasts, :owner_id
		add_index :podcasts, :title
		
		add_index :episodes, :podcast_id
		add_index :episodes, :title
		
		
	end

	def self.down
		drop_table :podcasts
		drop_table :episodes
	end
end
