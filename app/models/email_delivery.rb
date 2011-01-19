# == Schema Information
# Schema version: 20110105172220
#
# Table name: email_deliveries
#
#  id                   :integer(4)      not null, primary key
#  email_subscribing_id :integer(4)
#  email_message_id     :integer(4)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class EmailDelivery < ActiveRecord::Base
	belongs_to	:email_subscribing
	belongs_to	:email_message
end
