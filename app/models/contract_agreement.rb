class ContractAgreement < ActiveRecord::Base
	belongs_to	:contract
	belongs_to	:author
end
