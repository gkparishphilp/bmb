class SetDefaultShippingValues < ActiveRecord::Migration
  def self.up
	execute 'alter table skus alter domestic_shipping_price set default 0'
	execute 'alter table skus alter international_shipping_price set default 0'
  end

  def self.down
  end
end
