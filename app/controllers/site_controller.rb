class SiteController < ApplicationController
	before_filter	:require_admin, :except => :index
	
	def admin
		@site = Site.first
	end
	
	def index

	end

	def go_twitter
		oauth.set_callback_url( ret_twitter_site_index_url )
	  
		session['rtoken'] = oauth.request_token.token
		session['rsecret'] = oauth.request_token.secret
	  
		redirect_to oauth.request_token.authorize_url
	end
  
	def ret_twitter
		oauth.authorize_from_request( session['rtoken'], session['rsecret'], params[:oauth_verifier] )
	  
		session['rtoken'] = nil
		session['rsecret'] = nil

		if @profile = Twitter::Base.new( oauth ).verify_credentials
			pop_flash "Twitter association successful"
		else
			pop_flash "Oooops, something went wrong with Twitter association", :error
		end

		token = oauth.access_token.token
		secret = oauth.access_token.secret
		
		site = Site.first

		if site.twitter_account
			site.twitter_account.update_attributes( :token => token, :secret => secret, :twit_id => @profile.id, 
												:twit_name => @profile.screen_name )
		else
			site.create_twitter_account( :token => token, :secret => secret, :twit_id => @profile.id, 
												:twit_name => @profile.screen_name )
		end
		
		redirect_to admin_site_index_path
	  
	end
	
private
	def oauth
		@oauth ||= Twitter::OAuth.new(TWITTER_KEY, TWITTER_SECRET, :sign_in => true)
	end
	
end