# mailman_app.rb
require 'mailman'
require 'mailman/receiver/pop3'

# ---------- Initialization values ---------------------------
# Some are dependent on current location of this script

Mailman.config.rails_root = '../'
Mailman.config.pop3 = {
  :username => 'donotreply@backmybook.com',
  :password => 'gr0undsw3ll',
  :server   => 'pop.gmail.com',
  :port     => 995, # defaults to 110
  :ssl      => true # defaults to false
}

Mailman.config.logger = Logger.new('../log/mailman.log')
Mailman.config.ignore_stdin = true
Mailman.config.poll_interval = 3600



# ---------- DSL routes to process incoming mail --------------

Mailman::Application.run do
	from 'complaints@email-abuse.amazonses.com' do
		body=''
		message_body = message.body.decoded
		message_body.each_line { |line|
			line.chomp!
			line.chomp!('=')
			body += line
		}

		if bd = body.match(/http:\/\/backmybook.com\/unsubscribe\/(.{40})/)
			if sub = EmailSubscribing.find_by_unsubscribe_code( bd[1] )
				sub.update_attributes :status => 'unsubscribed with spamflag'
				Mailman.logger.info("#{Time.now} SUCCESS - unsubscribed #{bd[1]} \n")
			else
				Mailman.logger.info("#{Time.now} ERROR - could not unsubscribe #{bd[1]} \n")
			end
		else
			Mailman.logger.info('#{Time.now} ERROR - could not find unsubscribe link in message')
			Mailman.logger.info("#{message.to_s} \n")
		end
		
	end

	default do
		Mailman.logger.info("#{Time.now} INFO - Not an email from Amazon Email Abuse \n")
	end
end