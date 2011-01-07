class RemovePriceFromOrder < ActiveRecord::Migration
  def self.up
	add_column :orders, :tax_amount, :integer
	add_column :orders, :shipping_amount, :integer
	add_column :orders, :total, :integer
	execute 'update orders set total = price'
	remove_column :orders, :price
  end

  def self.down
	add_column :orders, :price, :integer
	execute 'update orders set price = total'
	remove_column :orders, :total
	remove_column :orders, :shipping_amount
	remove_column :orders, :tax_amount
  end
end
