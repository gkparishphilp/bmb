# == Schema Information
# Schema version: 20110826004210
#
# Table name: tax_rates
#
#  id               :integer(4)      not null, primary key
#  rate             :float
#  geo_state_abbrev :string(255)
#

class TaxRate < ActiveRecord::Base
	belongs_to	:geo_state
end
