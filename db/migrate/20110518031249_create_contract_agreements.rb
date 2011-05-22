class CreateContractAgreements < ActiveRecord::Migration
  def self.up
    create_table :contract_agreements do |t|
      t.integer :contract_id
      t.integer :author_id
      t.string :sig

      t.timestamps
    end
  end

  def self.down
    drop_table :contract_agreements
  end
end
