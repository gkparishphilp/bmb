class CreateAffiliates < ActiveRecord::Migration
	def self.up
		create_table :affiliates do |t|
			t.references	:user
			t.string		:code

			t.timestamps
		end
		
		add_index :affiliates, [ :user_id, :code ]
		
	end

	def self.down
		drop_table :affiliates
	end
end