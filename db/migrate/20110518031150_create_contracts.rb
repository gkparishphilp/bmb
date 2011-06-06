class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.string :name
      t.string :version
      t.text :content

      t.timestamps
    end

	add_index :contracts, :name
  end

  def self.down
    drop_table :contracts
  end
end
