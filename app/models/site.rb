class Site < ActiveRecord::Base
	
	has_many :links, :as => :owner
	has_one :twitter_account, :as => :owner
	
	#belongs_to :author
	
	def tweet( message, url )
		chars_left = 136 - url.length
		message = message[0..chars_left] + (message.length > chars_left ? "..." : "")
		message += url
		
		tweet = self.twitter_session.update( message )
		
	end
	
	def oauth
		@oauth ||= Twitter::OAuth.new( TWITTER_KEY, TWITTER_SECRET )
	end

	def twitter_session
		@session ||= begin
			oauth.authorize_from_access( self.twitter_account.token, self.twitter_account.secret ) 
			Twitter::Base.new( oauth )
		end
	end
	
	
end