class AddContactType < ActiveRecord::Migration
  def self.up
	add_column :contacts, :contact_type, :text
  end

  def self.down
	remove_column :contacts, :contact_type
  end
end
