# == Schema Information
# Schema version: 20110121210536
#
# Table name: tax_rates
#
#  id           :integer(4)      not null, primary key
#  geo_state_id :integer(4)
#  rate         :float
#

class TaxRate < ActiveRecord::Base
	belongs_to	:geo_state
end
