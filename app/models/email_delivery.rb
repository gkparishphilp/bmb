# == Schema Information
# Schema version: 20110327221930
#
# Table name: email_deliveries
#
#  id                   :integer(4)      not null, primary key
#  email_subscribing_id :integer(4)
#  email_message_id     :integer(4)
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  code                 :string(255)
#

class EmailDelivery < ActiveRecord::Base
	belongs_to	:email_subscribing
	belongs_to	:email_message
	
	def self.quota_remaining
		aws_ses = AWS::SES::Base.new(:access_key_id => AWS_ID, :secret_access_key => AWS_SECRET)
		response = aws_ses.quota
		quota_24_hrs = response.max_24_hour_send.to_i
		sent_24_hrs = response.sent_last_24_hours.to_i
		return quota_remaining = ((quota_24_hrs - sent_24_hrs) * 0.9).round
	end
	
	def generate_tracking_code
		random_string = rand(1000000000).to_s + Time.now.to_s
		if self.code == nil
			self.code = Digest::SHA1.hexdigest random_string
		end
		
	end
	
	def update_delivery_record_for( message, status )
		self.update_attributes :email_subscribing_id => self.email_subscribing.id , :email_message_id => message.id, :status => status
		self.generate_tracking_code
		self.save
	end
	

	
end
