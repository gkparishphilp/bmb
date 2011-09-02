# == Schema Information
# Schema version: 20110826004210
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  to_id      :integer(4)
#  to_type    :string(255)
#  from_id    :integer(4)
#  from_type  :string(255)
#  title      :string(255)
#  content    :text
#  deliver_at :datetime
#  status     :string(255)     default("publish")
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
	belongs_to	:email_campaign
	has_many	:email_deliveries
end
