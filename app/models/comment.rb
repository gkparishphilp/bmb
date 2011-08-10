# == Schema Information
# Schema version: 20110606205010
#
# Table name: comments
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  commentable_id      :integer(4)
#  commentable_type    :string(255)
#  reply_to_comment_id :integer(4)
#  ip                  :string(255)
#  content             :text
#  created_at          :datetime
#  updated_at          :datetime
#

class Comment < ActiveRecord::Base

	after_create :check_for_spam
	    
	belongs_to  :commentable, :polymorphic => :true
	belongs_to  :user

	validates_presence_of :content, :message => "You really should have to have something to say to post a comment :)"
	
	scope :published, where("status = 'publish'")
	
	acts_as_followed
	
	def self.filter_all_for_spam
		comments = self.where("status <> 'spam' ")
				
		banned_ips = SpamFilter.find_all_by_filter_type_and_filter_action('ip','spam')
		ips = banned_ips.map{ |record| record.filter_value}
		
		banned_emails = SpamFilter.find_all_by_filter_type_and_filter_action('email','spam')
		emails = banned_emails.map{ |record| record.filter_value}
		
		banned_keywords = SpamFilter.find_all_by_filter_type_and_filter_action('keyword','spam')
		keywords = banned_keywords.map{ |record| record.filter_value}
		
		for comment in comments
			comment.update_attributes :status => 'spam' if ips.include?(comment.ip)
							
			email = comment.user.email.gsub(/\./,"")
			comment.update_attributes :status => 'spam' if emails.include?(email)
			
			for keyword in keywords
				content = comment.content.downcase
				comment.update_attributes :status => 'spam' if content.match(keyword)
			end
		end
	end	
	
	def check_for_spam
		SpamFilter.filter( self )
	end
                


end



