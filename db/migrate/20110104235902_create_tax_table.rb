class CreateTaxTable < ActiveRecord::Migration
  def self.up
	create_table :tax_rates do |t|
		t.references	:geo_state
		t.float		:rate
	end
	
	r = TaxRate.create :geo_state_id => 1 , :rate => 0.04
	r = TaxRate.create :geo_state_id => 2 , :rate => 0
	r = TaxRate.create :geo_state_id => 3 , :rate => 0.056
	r = TaxRate.create :geo_state_id => 4 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 5 , :rate => 0.0825
	r = TaxRate.create :geo_state_id => 6 , :rate => 0.029
	r = TaxRate.create :geo_state_id => 7 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 8 , :rate => 0
	r = TaxRate.create :geo_state_id => 9 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 10 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 11 , :rate => 0.04

	r = TaxRate.create :geo_state_id => 12 , :rate => 0.04
	r = TaxRate.create :geo_state_id => 13 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 14 , :rate => 0.0625
	r = TaxRate.create :geo_state_id => 15 , :rate => 0.07
	r = TaxRate.create :geo_state_id => 16 , :rate => 0.06
	
	r = TaxRate.create :geo_state_id => 17 , :rate => 0.053
	r = TaxRate.create :geo_state_id => 18 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 19 , :rate => 0.04
	r = TaxRate.create :geo_state_id => 20 , :rate => 0.05
	r = TaxRate.create :geo_state_id => 21 , :rate => 0.06
	
	r = TaxRate.create :geo_state_id => 22 , :rate => 0.0625
	r = TaxRate.create :geo_state_id => 23 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 24 , :rate => 0.06875
	r = TaxRate.create :geo_state_id => 25 , :rate => 0.07
	r = TaxRate.create :geo_state_id => 26 , :rate => 0.04225
	
	r = TaxRate.create :geo_state_id => 27 , :rate => 0
	r = TaxRate.create :geo_state_id => 28 , :rate => 0.055
	r = TaxRate.create :geo_state_id => 29 , :rate => 0.0685
	r = TaxRate.create :geo_state_id => 30 , :rate => 0
	r = TaxRate.create :geo_state_id => 31 , :rate => 0.07
	
	r = TaxRate.create :geo_state_id => 32 , :rate => 0.05
	r = TaxRate.create :geo_state_id => 33 , :rate => 0.04
	r = TaxRate.create :geo_state_id => 34 , :rate => 0.0575
	r = TaxRate.create :geo_state_id => 35 , :rate => 0.05
	r = TaxRate.create :geo_state_id => 36 , :rate => 0.055
	
	r = TaxRate.create :geo_state_id => 37 , :rate => 0.045
	r = TaxRate.create :geo_state_id => 38 , :rate => 0
	r = TaxRate.create :geo_state_id => 39 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 40 , :rate => 0.07
	r = TaxRate.create :geo_state_id => 41 , :rate => 0.06
	
	r = TaxRate.create :geo_state_id => 42 , :rate => 0.04
	r = TaxRate.create :geo_state_id => 43 , :rate => 0.07
	r = TaxRate.create :geo_state_id => 44 , :rate => 0.0625
	r = TaxRate.create :geo_state_id => 45 , :rate => 0.047
	r = TaxRate.create :geo_state_id => 46 , :rate => 0.06
	
	r = TaxRate.create :geo_state_id => 47 , :rate => 0.05
	r = TaxRate.create :geo_state_id => 48 , :rate => 0.065
	r = TaxRate.create :geo_state_id => 49 , :rate => 0.06
	r = TaxRate.create :geo_state_id => 50 , :rate => 0.05
	r = TaxRate.create :geo_state_id => 51 , :rate => 0.04

	
  end

  def self.down
	drop_table :tax_rates
  end
end
