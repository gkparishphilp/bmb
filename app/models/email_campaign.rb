class EmailCampaign < ActiveRecord::Base
	has_many	:email_messages
	scope :default, where("Title = 'Default'")
end