class CreateAuthors < ActiveRecord::Migration
	def self.up
		# todo -- stub authors model; flesh out
		create_table :authors do |t|
			t.string	:pen_name
			
			t.string	:cached_slug

			t.timestamps
		end
	end

	def self.down
		drop_table :authors
	end
end
