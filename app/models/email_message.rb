# == Schema Information
# Schema version: 20110826004210
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
#  email_type        :string(255)
#  sender_id         :string(255)
#  sender_type       :string(255)
#  user_id           :string(255)
#  source_id         :string(255)
#  source_type       :string(255)
#

class EmailMessage < ActiveRecord::Base
	belongs_to	:source, :polymorphic => true
	has_many	:email_deliveries
	belongs_to	:sender, :polymorphic => true
	
	#Scopes 

	scope :created, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'created'" )
	scope :delivered, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'sent'" )
	scope :opened, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'opened'" )
	scope :bounced, joins( "join email_deliveries on email_deliveries.email_message_id = email_messages.id" ).where( "email_deliveries.status = 'bounced'" )
	
	scope :dated_between, lambda { |*args| 
		where( "emails_messages.created_at between ? and ?", (args.first.to_date || 7.days.ago.getutc), (args.second.to_date || Time.now.getutc) ) 
	}

	scope :for_author, lambda { |args|
		joins( "join email_campaigns on email_campaigns.id = email_messages.email_campaign_id " ).where( "email_campaigns.owner_type='Author' and email_campaigns.owner_id = ?", args )
	}
	
	scope :shipping, where("email_type = 'shipping'")
	
	def bounces
		self.email_deliveries.find(:all, :conditions  => "status = 'bounced'")
	end

	def deliveries
		self.email_deliveries.find(:all, :conditions  => "status = 'sent'")
	end
	
	def sent?
		self.status.match(/sent/i)
	end
	
	def build_html_email( args={})  #test, unsubscribe_code, #delivery_code
		message_header = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">" + "<head> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /> <title> #{self.subject}</title> <body>"
		message_footer = "</body></html>"
		if args[:test].present? 
			message_unsubscribe = "<p>To unsubscribe from this author's newsletter, please click here: *unsubscribe link goes here*  </p>"
			message = message_header + self.content.html_safe + message_unsubscribe + message_footer
		else
			unsubscribe_code = args[:unsubscribe_code]
			delivery_code = args[:delivery_code]
			message_unsubscribe = "<p> <img alt =\"logo\" src=\"http://backmybook.com/logo/#{delivery_code}\" /> To unsubscribe from this author's newsletter, please click here: <a href=\"http://backmybook.com/unsubscribe/#{unsubscribe_code}\">Unsubscribe</a></p>"
			message = message_header + self.content.html_safe + message_unsubscribe + message_footer
		end	 
		
		return message
	end
	
	def deliver_to( subscriptions )
		count = 0
		
		# Check and see how much quota we've got left on Amazon SES and break it up according to quota
		# todo - this needs to be refactored for when multiple authors are sending newsletters
		# Need to look at the delayed_job queues and see how many email slots are open for that day
	
		quota_remaining = EmailDelivery.quota_remaining
		for subscription in subscriptions
			
			# Create an email_delivery entry so we have a unique tracking code to track status of this email over time
			# todo - make the creation of the tracking code an after create filter for the delivery record
			delivery_record = subscription.email_deliveries.create
			delivery_record.update_delivery_record_for( self, 'created')
			
			# Create HTML email message to be sent through AWS SES
			html_body = self.build_html_email(:unsubscribe_code => subscription.unsubscribe_code, :delivery_code => delivery_record.code)

			#Calculate n days away we can schedule the send based on Amazon SES quota availability
			n = count.divmod( quota_remaining).first.to_i
			
			# Kick it to delayed_job to manage the send time and send load
			if Delayed::Job.enqueue( SendEmailJob.new(subscription.subscriber, "#{self.sender.pen_name} <donotreply@backmybook.com>", "#{self.subject}", html_body), 0 , n.days.from_now.getutc )
				delivery_record.update_attributes :status => 'sent'
			else
				delivery_record.update_attributes :status => 'error : could not put into delayed job queue' 
			end
			
			count += 1
		end
		self.update_attributes :status => "Sent #{Time.now.to_date}"
	end

end
