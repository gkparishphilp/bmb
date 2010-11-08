# == Schema Information
# Schema version: 20101103181324
#
# Table name: email_campaigns
#
#  id                :integer(4)      not null, primary key
#  owner_id          :integer(4)
#  owner_type        :string(255)
#  email_template_id :integer(4)
#  title             :string(255)
#  status            :string(255)
#  campaign_type     :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class EmailCampaign < ActiveRecord::Base
	has_many	:email_messages
	scope :default, where("Title = 'Default'")
end
