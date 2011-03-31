class AddShowInventoryToMerch < ActiveRecord::Migration
  def self.up
	add_column :merches, :show_inventory_count_at, :integer, :default => 0
	add_column :orders, :sku_quantity, :integer, :default => 1
	
  end

  def self.down
	remove_column :merches, :show_inventory_count_at
	remove_column :orders, :sku_quantity
  end
end
