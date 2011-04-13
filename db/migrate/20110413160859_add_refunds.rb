class AddRefunds < ActiveRecord::Migration
  def self.up
	create_table :refunds do |t|
		t.references :order
		t.integer :item_amount
		t.integer :shipping_amount
		t.integer :tax_amount
		t.integer :total
		t.string  :params
		t.string  :comment
	end
  end

  def self.down
	drop_table :refunds
  end
end
