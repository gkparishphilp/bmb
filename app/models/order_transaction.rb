# == Schema Information
# Schema version: 20110606205010
#
# Table name: order_transactions
#
#  id         :integer(4)      not null, primary key
#  order_id   :integer(4)
#  price      :integer(4)
#  message    :string(255)
#  reference  :string(255)
#  action     :string(255)
#  params     :text
#  success    :boolean(1)
#  test       :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class OrderTransaction < ActiveRecord::Base
	belongs_to :order
	serialize :params
	liquid_methods :reference
end
