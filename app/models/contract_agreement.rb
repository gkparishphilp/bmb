# == Schema Information
# Schema version: 20110602231354
#
# Table name: contract_agreements
#
#  id          :integer(4)      not null, primary key
#  contract_id :integer(4)
#  author_id   :integer(4)
#  sig         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class ContractAgreement < ActiveRecord::Base
	belongs_to	:contract
	belongs_to	:author
end
