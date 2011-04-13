class AddRefunds < ActiveRecord::Migration
  def self.up
	create_table :refunds do |t|
		t.references :order
		t.integer :amount
		t.integer :shipping_amount
		t.integer :fee_amount
		t.integer :tax_amount
		t.string  :reference
		t.string  :comment
	end
	add_index :refunds, :reference
  end

  def self.down
	remove_index :refunds, :reference
	drop_table :refunds
  end
end
