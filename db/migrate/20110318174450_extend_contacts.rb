class ExtendContacts < ActiveRecord::Migration
	def self.up
		add_column	:crashes, :user_note, :text
		
		add_column	:contacts, :author_id, :integer
		add_column	:contacts, :user_id, :integer
		add_column	:contacts, :phone, :string
		add_column	:contacts, :web_address, :string
		add_column	:contacts, :referrer, :string

	end

	def self.down
		remove_column	:crashes, :user_note
		remove_column	:contacts, :author_id
		remove_column	:contacts, :phone
		remove_column	:contacts, :web_address
		remove_column	:contacts, :referrer
		remove_column	:contacts, :user_id
	end
end
