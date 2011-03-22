class InventoryFix < ActiveRecord::Migration
  def self.up
	remove_column :skus, :number_remaining
	add_column :merches, :inventory_warning, :integer, :default => -1
  end

  def self.down
	add_column :skus, :number_remaining, :integer, :default => -1
	remove_column :merches, :inventory_warning
  end
end
