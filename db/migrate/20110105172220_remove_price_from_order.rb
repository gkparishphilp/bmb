class RemovePriceFromOrder < ActiveRecord::Migration
  def self.up
	add_column :orders, :total, :integer
	execute 'update orders set total = price'
	remove_column :orders, :price
  end

  def self.down
	add_column :orders, :price, :integer
	execute 'update orders set price = total'
	remove_column :orders, :total
  end
end
