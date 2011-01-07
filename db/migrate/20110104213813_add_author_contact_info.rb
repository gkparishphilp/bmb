class AddAuthorContactInfo < ActiveRecord::Migration
  def self.up
	add_column :authors, :contact_email, :string
	add_column :authors, :contact_phone, :string
  end

  def self.down
	remove_column :authors, :contact_email
	remove :authors, :contact_phone
  end
end
