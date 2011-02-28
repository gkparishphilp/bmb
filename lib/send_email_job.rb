class SendEmailJob  < Struct.new(:recipient, :source, :subject, :html_body)

	def perform 
		ses = AWS::SES::Base.new(:access_key_id => AWS_ID, :secret_access_key => AWS_SECRET)
		ses.send_email( :to => recipient, :source => source, :subject => subject, :html_body => html_body)
	end

end