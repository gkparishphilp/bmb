class AddFeaturedToBooks < ActiveRecord::Migration
	def self.up
		add_column	:books, :featured, :boolean
	end

	def self.down
		remove_column	:books, :featured
	end
end
