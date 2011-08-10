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
		Comment.filter_all_for_spam
	end
end