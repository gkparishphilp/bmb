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
	
	#Scopes 

	scope :created, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'created'" )
	scope :sent, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'sent'" )
	scope :opened, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'opened'" )
	scope :bounced, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'bounced'" )

	
	scope :dated_between, lambda { |*args| 
		where( "emails_messages.created_at between ? and ?", (args.first.to_date || 7.days.ago.getutc), (args.second.to_date || Time.now.getutc) ) 
	}

	scope :for_author, lambda { |args|
		joins( "join email_campaigns on email_campaigns.id = email_messages.email_campaign_id " ).where( "email_campaigns.owner_type='Author' and email_campaigns.owner_id = ?", args )
	}
	
	def bounces
		self.email_deliveries.find(:all, :conditions  => "status = 'bounced'")
	end

	def sends
		self.email_deliveries.find(:all, :conditions  => "status = 'sent'")
	end


end
