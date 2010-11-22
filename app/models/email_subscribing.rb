# == Schema Information
# Schema version: 20101120000321
#
# Table name: email_subscribings
#
#  id                 :integer(4)      not null, primary key
#  subscribed_to_id   :integer(4)
#  subscribed_to_type :string(255)
#  subscriber_id      :integer(4)
#  subscriber_type    :string(255)
#  unsubscribe_code   :string(255)
#  status             :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

# Email subscribings relate users and authors (the subscriber) to email campaigns (subscribed_to).  
# The subscribed_to shouldn't be an email_message however, since logically, all email_messages should belong_to an email_campaign

class EmailSubscribing < ActiveRecord::Base
	belongs_to	:subscribed_to, :polymorphic => true
	belongs_to	:subscriber, :polymorphic => true
	has_many	:email_deliveries
	
	validates :unsubscribe_code, :uniqueness => true
	
	def generate_unsubscribe_code
		random_string = rand(1000000000).to_s + Time.now.to_s
		if self.unsubscribe_code == nil
			self.unsubscribe_code = Digest::SHA1.hexdigest random_string
		end
		
	end
end
