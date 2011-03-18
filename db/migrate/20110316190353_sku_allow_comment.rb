class SkuAllowComment < ActiveRecord::Migration
  def self.up
	add_column :skus, :allow_comment, :boolean, :default => false
	add_column :orders, :comment, :text
	add_column :skus, :number_remaining, :integer, :default => -1
	add_column :skus, :listing_order, :integer
  end

  def self.down
	remove_column :skus, :allow_comment
	remove_column :orders, :comment
	remove_column :skus, :number_remaining
	remove_column :skus, :listing_order
  end
end
