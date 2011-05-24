class AuthorMenuPermissions < ActiveRecord::Migration
  def self.up
	add_column :authors, :enable_blog, :boolean, :default => false
	add_column :authors, :enable_store, :boolean, :default => true
	add_column :authors, :enable_help, :boolean, :default => true
	add_column :authors, :enable_bio, :boolean, :default => false
	add_column :authors, :enable_forums, :boolean, :default => false
  end

  def self.down
	remove_column :authors, :enable_blog
	remove_column :authors, :enable_store
	remove_column :authors, :enable_help
	remove_column :authors, :enable_bio
	remove_column :authors, :enable_forums
  end
end
