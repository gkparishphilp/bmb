# == Schema Information
# Schema version: 20110602231354
#
# Table name: contracts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  version    :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Contract < ActiveRecord::Base
	has_many	:contract_agreements
end
