# == Schema Information
# Schema version: 20110826004210
#
# Table name: spam_filters
#
#  id            :integer(4)      not null, primary key
#  filter_type   :string(255)
#  filter_value  :string(255)
#  filter_action :string(255)
#

class SpamFilter < ActiveRecord::Base
	after_create :filter_comments
	
	def self.filter( ugc )

		if ugc.ip && filter = SpamFilter.find_by_filter_type_and_filter_value( 'ip', ugc.ip )
			ugc.update_attributes :status => filter.filter_action
		end

		if ugc.user 
			email = ugc.user.email.gsub(/\./,"")
			if filter = SpamFilter.find_by_filter_type_and_filter_value( 'email', email )
				ugc.update_attributes :status => filter.filter_action
			end
		end

		if ugc.content
			keyword_filters = SpamFilter.find_all_by_filter_type('keyword') 
			for keyword_filter in keyword_filters
				content = ugc.content.downcase
				if content.match(keyword_filter.filter_value)
					ugc.update_attributes :status => keyword_filter.filter_action
				end
			end
		end
	
	end
	
	
	private
	
	def filter_comments
		comments = Comment.where("status <> 'spam' ")
				
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
end
