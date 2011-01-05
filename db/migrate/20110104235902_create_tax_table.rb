class CreateTaxTable < ActiveRecord::Migration
  def self.up
	create_table :tax_rates do |t|
		t.references	:geo_state
		t.float		:rate
	end
  end

  def self.down
	drop_table :tax_rates
  end
end
