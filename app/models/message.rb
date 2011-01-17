class Message < ActiveRecord::Base
	belongs_to	:email_campaign
	has_many	:email_deliveries
end