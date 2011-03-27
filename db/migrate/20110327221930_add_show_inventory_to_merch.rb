class AddShowInventoryToMerch < ActiveRecord::Migration
  def self.up
	add_column :skus, :show_inventory, :boolean, :default => false
	
  end

  def self.down
	remove_column :skus, :show_inventory
  end
end
