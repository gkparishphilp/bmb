class SkuAllowComment < ActiveRecord::Migration
  def self.up
	add_column :skus, :allow_comment, :boolean, :default => false
	add_column :orders, :comment, :text
  end

  def self.down
	remove_column :skus, :allow_comment
	remove_column :orders, :comment
  end
end
