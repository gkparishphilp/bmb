class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :fetch_site, :fetch_author, :fetch_logged_in_user
	# so, we set these application-level global instance vars:
	# @current_site -- the site we're on -- basically the domain the app is running on
	# @current_user -- the user who is logged in (Anonymous user if no session)
	# @current_author -- the author who is logged in (nil if no author)
	# @author -- the author resource (if any) that is being requested (e.g. author page or site, forum, blog, etc.)

protected
	# Grabs @current_user from session cookie also sets @current_author
	def fetch_logged_in_user
		@current_user = ( session[:user_id] && User.find( session[:user_id] ) ) || User.anonymous
		@current_user.human = @current_user.logged_in? || cookies[:human] == 'true'
		@current_author = @current_user.author
	end
	
	# Sets @author from either subdomain or params[:author_id]
	def fetch_author
		if request.subdomain.present? && !APP_SUBDOMAINS.include?( request.subdomain )
			@author = Author.find_by_subdomain request.subdomain
		elsif params[:author_id].present?
			@author = Author.find params[:author_id]
		end
		@theme = @author.theme unless @author.nil? || @author.theme.nil?
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
		if flash[code].blank?
			flash[code] = "<b>#{message}</b>"
		else
			flash[code] += "<b>#{message}</b>"
		end
		
		object.each do |obj|
			obj.errors.each do |field, msg|
				flash[code] += "<br>" + field.to_s + ": " if field
				flash[code] += " " + msg 
			end
		end
	end
	
	def process_attachments_for( obj )
	for key in params.keys do
		if key =~ /attached_(.+)_/
			resource = params[key] unless params[key].blank?
			attach = Attachment.create_from_resource( resource, $1, :owner => obj )
			pop_flash "There was a problem with the #{attach.name} Attachment", :error, attach unless attach.errors.empty?
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
			pop_flash  "Please log in first", :notice
			@dest = request.url
			redirect_to new_session_path
			return false
		end
	end
	
	def require_validated
		unless @current_user.validated?
			pop_flash "Must have validated email", :notice
			redirect_to root_path
			return false
		end
	end
	
	def require_author
		if @current_author.nil?
			pop_flash "Must be logged in as an author", :notice
			redirect_to root_path
			return false
		end
	end
	
	def require_user_can_manage( object )
		unless ( object.user == @current_user ) || ( @current_site.admins.include? @current_user )
			pop_flash "Not your #{object.class.to_s}", :error
			redirect_to root_path
			return false
		end
	end
	
	def require_author_can_manage( object )
		#todo
	end
	
	# sets page metadata like page title and description
	def set_meta( title, *description )
		@title = title
		@description = description.first[0..200] unless description.first.blank?
	end
	
	
end
