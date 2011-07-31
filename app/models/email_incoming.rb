class EmailIncoming < ActionMailer::Base

	def receive(mail)
		logger.info("Got a mail from #{mail.from} about: #{mail.subject}")		
		mail_from = mail.from.to_s
		mail_body = mail.body.to_s
		logger.info("MAIL_FROM: #{mail_from}" )
		logger.info("MAIL_BODY: #{mail_body}" )
		logger.info("END MAIL_BODY")
		# Process abuse complaints by unsubscribing the user	
		if mail_from.match(/email-abuse.amazonses.com/i)
			logger.info("Inside the abuse loop")
			#Strip all '=' and carriage returns in the body because Amazon inserts them as line breaks
			body=''
			mail_body.each_line { |line|
				logger.info("LINE: #{line}")
				logger.info("BODY: #{body}")
				line.chomp!
				line.chomp!('=')
				body += line
			}
			code_array = body.match(/http:\/\/backmybook.com\/unsubscribe\/(.{40})">/)
			code = code_array[1]
			logger.info("BODY: #{mail_body}")
			logger.info("CODE = #{code}")
		end
	end
end