class MarketingMailer < ActionMailer::Base

	def send_to_self( message, author )
		# setup instance variables for the view
		@author = author
		@message = message
		
		mail :to => "#{@author.user.email}", :from => "#{@author.user.email}", :subject => "Self Test #{message.subject}"
	end

	
end
