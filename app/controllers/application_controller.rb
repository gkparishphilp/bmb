class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :fetch_site, :fetch_logged_in_user

protected
	# Grabs @current_user from session cookie
	def fetch_logged_in_user
		#@current_user = ( session[:user_id] && User.find( session[:user_id] ) ) || User.anonymous
		@current_user = User.find 2
		@current_user.human = @current_user.logged_in? || cookies[:human] == 'true'
	end
	
	# grabs @current_site from request.domain
	def fetch_site
		@domain = request.domain
		@current_site = Site.find_by_domain @domain || Site.first
	end
	
	# simply sets session cookie for passed-in user
	def login( user )
		@current_user = user
		session[:user_id] = user.id
		user.update_attributes :last_ip => request.ip
	end
	
	#simply clears the session cookie
	def logout( user )
		@current_user = session[:user_id] = nil
		cookies[:human] = nil
	end
	
	# populates the flash with message and error messages if any
	def pop_flash( message, code = :success, *object )
		flash[code] = "<b>#{message}</b>"
		
		object.each do |obj|
			obj.errors.each do |field, msg|
				flash[code] += "<br>" + field.to_s + ": " if field
				flash[code] += " " + msg 
			end
		end
	end
	
	
	# Controller filters -- todo -- add @current_user.validated? for filter on valid email
	def require_admin
		if @current_user.anonymous?
			flash[:notice] = "Please log in first"
			redirect_to new_session_path
			return false
		else
			unless @current_user.admin? @current_site
				flash[:notice] = "Admins Only"
				redirect_to root_path
				return false
			end
		end
	end
	
	def require_contributor
		if @current_user.anonymous?
			flash[:notice] = "Please log in first"
			redirect_to new_session_path
			return false
		else
			unless @current_user.contributor? @current_site
				flash[:notice] = "Contributors Only"
				redirect_to root_path
				return false
			end
		end
	end

	def require_login
		if @current_user.anonymous?
			flash[:notice] = "Please log in first"
			@dest = request.url
			redirect_to new_session_path
			return false
		end
	end
	
	def require_user_owns( object )
		unless ( object.user == @current_user ) || ( @current_site.admins.include? @current_user )
			pop_flash "Not your #{object.class.to_s}", :error
			redirect_to root_path
			return false
		end
	end
	
	# sets page metadata like page title and description
	def set_meta( title, *description )
		@title = title
		@description = description.first[0..200] unless description.first.blank?
	end
	
	
end
