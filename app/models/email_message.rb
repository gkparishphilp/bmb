# == Schema Information
# Schema version: 20110104222559
#
# Table name: email_messages
#
#  id                :integer(4)      not null, primary key
#  email_campaign_id :integer(4)
#  subject           :string(255)
#  content           :text
#  deliver_at        :datetime
#  status            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class EmailMessage < ActiveRecord::Base
	belongs_to	:email_campaign
	has_many	:email_deliveries
end
