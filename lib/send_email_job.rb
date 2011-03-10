class SendEmailJob  < Struct.new(:user, :source, :subject, :html_body)
	def perform
		if user.valid?
			ses = AWS::SES::Base.new(:access_key_id => AWS_ID, :secret_access_key => AWS_SECRET)
			ses.send_email( :to => user.email, :source => source, :subject => subject, :html_body => html_body)
		end
	end

end