class AssociateMerchToBook < ActiveRecord::Migration
  def self.up
	add_column :merches, :book_id, :integer
  end

  def self.down
	remove_column :merches, :book_id
  end
end
