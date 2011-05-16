class AddRefunds < ActiveRecord::Migration
  def self.up
	create_table :refunds do |t|
		t.references :order
		t.integer :item_amount, :default => 0
		t.integer :shipping_amount, :default => 0
		t.integer :tax_amount, :default => 0
		t.integer :total, :default => 0
		t.string  :params
		t.string  :comment
		t.boolean :status
		t.timestamps
	end
  end

  def self.down
	drop_table :refunds
  end
end
