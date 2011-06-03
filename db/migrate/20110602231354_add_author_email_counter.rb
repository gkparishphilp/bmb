class AddAuthorEmailCounter < ActiveRecord::Migration
  def self.up
	add_column :authors, :emails_sent_this_month, :integer, :default => 0
  end

  def self.down
	remove_column :authors, :emails_sent_this_month
  end
end
