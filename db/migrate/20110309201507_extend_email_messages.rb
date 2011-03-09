class ExtendEmailMessages < ActiveRecord::Migration
  def self.up
	add_column	:email_messages, :email_type, :string
	add_column	:email_messages, :sender_id, :string
	add_column	:email_messages, :sender_type, :string
	add_column	:email_messages, :user_id, :string
	add_column	:email_messages, :owner_id, :string
	add_column	:email_messages, :owner_type, :string
	
	add_index :email_messages, :email_type
	add_index :email_messages, :user_id
  end

  def self.down
	remove_index :email_messages, :email_type
	remove_index :email_messages, :user_id
	remove_column	:email_messages, :email_type
	remove_column	:email_messages, :sender_id
	remove_column	:email_messages, :sender_type
	remove_column	:email_messages, :user_id
	remove_column	:email_messages, :owner_id
	remove_column	:email_messages, :owner_type
  end
end
