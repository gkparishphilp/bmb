class AddMerchType < ActiveRecord::Migration
  def self.up
	add_column :merches, :merch_type, :text
  end

  def self.down
	remove_column :merches, :merch_type
  end
end
