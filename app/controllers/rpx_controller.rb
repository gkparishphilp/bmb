require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'digest/md5'

class RpxController < ApplicationController
	protect_from_forgery :except => [:index, :add_id]
	
	def index
		rpx_token = params[:token]
		dest = params[:dest]
		
		rpx = Net::HTTP.new('rpxnow.com', 443)
		rpx.use_ssl = true
		path = "/api/v2/auth_info"
		args = "apiKey=#{RPX_API_KEY}&token=#{rpx_token}"
		http_resp, response_data = rpx.post( path, args )

		@rpx_data = JSON.parse( response_data )
		
		profile = @rpx_data['profile']
		
		openid = Openid.find_by_identifier(profile['identifier'])
		if openid.nil?
			user = User.new 
			openid = Openid.new
			email_address = profile['verifiedEmail'] || profile['email']
			user.email = email_address
			user.activated_at = Time.now if !user.email.blank?
			user.status = 'first'
			
			user.display_name = profile['displayName']
			
			if User.find_by_user_name(profile['preferredUsername'])
				user.user_name = profile['providerName']+'_'+profile['preferredUsername']
			else
				user.user_name = profile['preferredUsername']
			end

			user.photo_url = profile['photo'] || "/images/anon_user.jpg"
			
			openid.identifier = profile['identifier']
			openid.provider = profile['providerName']
			openid.name = profile['preferredUsername']
			user.openids << openid
			user.orig_ip = request.ip
			
			user.save!
			
			user.join_the_site
			
		else
			user = User.find(openid.user_id)
		end

		session[:user_id] = user.id
		
		@current_user = User.find_by_id( user.id )
		
		@current_user.update_attributes :last_ip => request.ip
		
		pop_flash "OpenID Login successful"
		
		if @current_user.email.nil?
				flash[:success] += "	Must provide Email Address"
				redirect_to user_path( @current_user )
		else
			dest = user_path( @current_user ) if @current_user.status == 'first'
			dest = new_upload_file_path if params[:a]
			dest ||= root_path
			redirect_to dest
		end
		
	end
	
	def add_id
		if request.post?
			rpx_token = params[:token]
			user_id = params[:user_id]

			rpx = Net::HTTP.new('rpxnow.com', 443)
			rpx.use_ssl = true
			path = "/api/v2/auth_info"
			args = "apiKey=#{RPX_API_KEY}&token=#{rpx_token}"
			http_resp, response_data = rpx.post( path, args )

			@rpx_data = JSON.parse( response_data )

			profile = @rpx_data['profile']
			
			requesting_user = User.find_by_id(user_id)
			openid = Openid.find_by_identifier(profile['identifier'])
			
			if openid.nil?
				#this is a new one...
				openid = Openid.new
				openid.identifier = profile['identifier']
				openid.provider = profile['providerName']
				openid.name = profile['preferredUsername']
				
				requesting_user.openids << openid
				requesting_user.save!
				flash[:success] = "OpenID added...."
			else
				if requesting_user.id == openid.user_id
					flash[:notice] = "This openid is already associated with your account"
				else
				#crap, this openid already exists and is tied to another user...
				original_user = User.find_by_id( openid.user_id )
				# Assign alt_emails to new user
				if !requesting_user.alt_emails.include?(original_user.email) && requesting_user.email != original_user.email
					new_email = AltEmail.new(:address=>original_user.email)
					requesting_user.alt_emails << new_email
				end
				original_user.alt_emails.each do |email|
					email.user_id = requesting_user.id if !requesting_user.alt_emails.include?(email)
					email.save!
				end
				
				#Make the association..
				requesting_user.openids << openid
				requesting_user.save!
				
				#Nuke the original user....
				original_user.destroy
				
				flash[:success] = "OpenID added, along with any original user data..."
				end
			end
			
			redirect_to account_settings_path
			
		else # Get request -- just show the form...
			@title = "Associate Account"
		end
		
	end
	
end
