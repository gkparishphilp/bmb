class AddCodeToEmailDelivery < ActiveRecord::Migration
  def self.up
	add_column :email_deliveries, :code, :string
	add_index :email_deliveries, :code
  end

  def self.down
	remove_index :email_deliveries, :code
	remove_column :email_deliveries, :code
  end
end
