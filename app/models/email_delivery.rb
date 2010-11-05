class EmailDelivery < ActiveRecord::Base
	belongs_to	:email_subscribing
	belongs_to	:email_message
end