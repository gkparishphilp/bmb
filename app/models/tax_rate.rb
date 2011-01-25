# == Schema Information
# Schema version: 20110104222559
#
# Table name: tax_rates
#
#  id               :integer(4)      not null, primary key
#  geo_state_id     :integer(4)
#  rate             :float
#  geo_state_abbrev :string(255)
#

class TaxRate < ActiveRecord::Base
	belongs_to	:geo_state
end
