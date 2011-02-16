class MarketingMailer < ActionMailer::Base

	def send_to_self( message, author )
		# setup instance variables for the view
		@author = author
		@message = message
		
		mail :to => "#{@author.user.email}", :from => "#{@author.user.email}", :subject => "#{message.subject} (Test Message)"
	end

	def send_to_all( message, author, subscription, delivery_record )
		# setup instance variables for the view
		@author = author
		@message = message
		@subscription = subscription
		@delivery_record = delivery_record
		mail :to => "#{@subscription.subscriber.email}", :from => "#{@author.user.email}", :subject => "#{message.subject}"
	end
	
end
