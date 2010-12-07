class AddShippingPriceToSku < ActiveRecord::Migration
  def self.up
	add_column :skus, :domestic_shipping_price, :integer
	add_column :skus, :international_shipping_price, :integer
  end

  def self.down
	remove_column :skus, :domestic_shipping_price
	remove_column :skus, :international_shipping_price, :integer
  end
end
