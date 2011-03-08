class MarketingMailer < ActionMailer::Base

	#Used for SMTP send, but NOT for AWS SES email sends
	
	def send_to_self( message, author )
		# setup instance variables for the view
		@author = author
		@message = message
		
		mail :to => "#{@author.user.email}", :from => "#{@author.pen_name} <#{@author.contact_email}>", :subject => "#{message.subject} (Test Message)"
	end

	def send_to_subscriber( message, author, subscription, delivery_record )
		# setup instance variables for the view
		@author = author
		@message = message
		@subscription = subscription
		@delivery_record = delivery_record
		mail :to => "#{@subscription.subscriber.email}", :from => "#{@author.pen_name} <#{@author.contact_email}>", :subject => "#{message.subject}"
	end
	
end