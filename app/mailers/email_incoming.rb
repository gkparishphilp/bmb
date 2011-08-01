class EmailIncoming < ActionMailer::Base

	def receive(mail)
		logger.info("Got a mail from #{mail.from} about: #{mail.subject}")		
		mail_from = mail.from.to_s
		mail_body = mail.body.to_s
		# Process abuse complaints by unsubscribing the user	
		if mail_from.match(/email-abuse.amazonses.com/i)
			#Strip all '=' and carriage returns in the body because Amazon inserts them as line breaks
			body=''
			mail_body.each_line { |line|
				line.chomp!
				line.chomp!('=')
				body += line
			}
			code_array = body.match(/http:\/\/backmybook.com\/unsubscribe\/(.{40})">/)
			code = code_array[1].to_s
			logger.info("CODE = #{code}")
			
			if sub = EmailSubscribing.find_by_unsubscribe_code( code )
				sub.update_attributes :status => "unsubscribed - spam abuse"
			end
		end
	end
end