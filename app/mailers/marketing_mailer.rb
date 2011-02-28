class MarketingMailer < ActionMailer::Base

	def send_to_self( message, author )
		# setup instance variables for the view
		@author = author
		@message = message
		ses = AWS::SES::Base.new(:access_key_id => AWS_ID, :secret_access_key => AWS_SECRET)
		ses.send_email( :to => ["#{@author.user.email}"], :source => '<donotreply@backmybook.com>', :subject => "#{message.subject} (Test Message)", :text_body => '<html><body><b>Test Message</b></body>,</html>')

	end

	def send_to_subscriber( message, author, subscription, delivery_record )
		# setup instance variables for the view
		@author = author
		@message = message
		@subscription = subscription
		@delivery_record = delivery_record
		ses = AWS::SES::Base.new(:access_key_id => AWS_ID, :secret_access_key => AWS_SECRET)
		ses.send_raw_email :to => "#{@subscription.subscriber.email}", :from => "#{@author.pen_name} <donotreply@backmybook.com>", :subject => "#{message.subject}"
	end
	
end
