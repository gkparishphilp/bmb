class SessionsController < ApplicationController
	def new
		@dest = params[:dest]
	end
  
	def create
		user = User.authenticate(params[:email], params[:password])
		dest = params[:dest]
		if user
			if user.status == "pending"
				pop_flash "The email for account has not been activated yet.  Please check your email account for your activation email.", :notice
				redirect_to pending_sessions_path( :user_id => user.id )
				return false
			else
				session[:user_id] = user.id
				user.update_attributes :last_ip => request.ip
			
				pop_flash  "#{user.email} successfully logged in"
				if dest.empty? || dest == "/"
					redirect_to user_path( user )
				else
					redirect_to dest
				end
			end
		else
			params[:password] = nil
			@user = User.new
			@dest = dest
			pop_flash "Invalid user/password combination", :error
			redirect_to new_session_path
		end
	end

	def destroy
		if @current_user
			dest = params[:dest]
			user = User.find_by_id(@current_user.id)
			@current_user = session[:user_id] = nil
			#should refactor this out???
			cookies[:human] = nil
			flash[:notice] = user.name + " logged out"

			redirect_to root_path

		else
			flash[:notice] = "No one logged in"
			redirect_to :action => "new" 
		end
	end
	
	def pending
		if @current_user.anonymous?
			@user = User.find params[:user_id]
		else
			@user = @current_user
		end
	end
  
	def go_twitter
		oauth.set_callback_url( ret_twitter_sessions_url )
	  
		session['rtoken'] = oauth.request_token.token
		session['rsecret'] = oauth.request_token.secret
	  
		redirect_to oauth.request_token.authorize_url
	end
  
	def ret_twitter
		oauth.authorize_from_request( session['rtoken'], session['rsecret'], params[:oauth_verifier] )
	  
		session['rtoken'] = nil
		session['rsecret'] = nil

		@profile = Twitter::Base.new( oauth ).verify_credentials

		token = oauth.access_token.token
		secret = oauth.access_token.secret
		
		account = TwitterAccount.find_by_twit_id( @profile.id )

		if !account.nil? && @current_user.anonymous?
			user = account.owner
			account.update_attributes( :token => token, :secret => secret )
			flash[:success] = "Twitter login successful"
		elsif !account.nil? && !@current_user.anonymous?
			account.update_attributes( :atoken => token, :asecret => secret, :twitter_id => @profile.id, 
												:twitter_name => @profile.screen_name )
			flash[:success] = "Twitter Account added"
		else # account was nil
			user = User.create_from_twitter( @profile, token, secret )
			flash[:success] = "Twitter registration successful"
		end
	  
		if user
			@current_user = user 
			@current_user.update_attributes :last_ip => request.ip
			session[:user_id] = @current_user.id
		end

		redirect_to @current_user
	  
	end
 
private

	def oauth
		@oauth ||= Twitter::OAuth.new(TWITTER_KEY, TWITTER_SECRET, :sign_in => true)
	end

end
