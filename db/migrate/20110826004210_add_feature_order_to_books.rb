class AddFeatureOrderToBooks < ActiveRecord::Migration
  def self.up
	add_column :books, :feature_listing_order, :integer
  end

  def self.down
	remove_column :books, :feature_listing_order
  end
end
