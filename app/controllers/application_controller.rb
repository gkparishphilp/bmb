class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :fetch_site, :fetch_author, :fetch_logged_in_user
	# so, we set these application-level global instance vars:
	# @current_site -- the site we're on -- basically the domain the app is running on
	# @current_user -- the user who is logged in (Anonymous user if no session)
	# @current_author -- the author who is logged in (nil if no author)
	# @author -- the author resource (if any) that is being requested (e.g. author page or site, forum, blog, etc.)
	# @theme the theme the author is using, if any

protected

	def http_auth
		authenticate_or_request_with_http_basic do |name, pass|
			name == 'admin' && pass == 'gr0undsw3ll'
		end
	end

	# Custom 404s & 500 catch-all
	if Rails.env.production?
		rescue_from ActionController::UnknownAction, :with => :invalid_method
		rescue_from ActionController::RoutingError, :with => :invalid_method
		rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
		rescue_from Exception, :with => :server_error
	end

	# Grabs @current_user from session cookie also sets @current_author
	def fetch_logged_in_user
		@current_user = ( session[:user_id] && User.find( session[:user_id] ) ) || User.anonymous
		@current_user.human = @current_user.logged_in? || cookies[:human] == 'true'
		@current_author = @current_user.author
	end
	
	# Sets @author from either subdomain or params[:author_id]
	def fetch_author
		return if @author.present?
		if request.subdomain.present? && !APP_SUBDOMAINS.include?( request.subdomain )
			@author = Author.find_by_subdomain request.subdomain
		elsif params[:author_id].present?
			@author = Author.find params[:author_id]
		end
		@theme = @author.active_theme unless @author.nil? || @author.active_theme.nil?
	end
	
	# grabs @current_site from request.domain
	def fetch_site
		@domain = request.domain
		@current_site = Site.find_by_domain @domain || Site.first
		@author = @current_site.author
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
		# the idea is to scan the params has for any fields with names matching "attached_whatever_something"
		# like "attached_avatar_file", or "attached_photos_url" -- this method will take the value be it a file
		# upload resource or a url and either update the attachment (if the attachment is a singular resource and
		# the owning object has one already) or create a new one (otherise).  So, attachemnt collections are always added to
		for key in params.keys do
			if key =~ /attached_(.+)_/
				next if params[key].blank?
				resource = params[key]
				if ( eval "obj.#{$1}" ) && !( eval "obj.#{$1}.respond_to? 'each'" )
					# the object has an attachemnt of that type in the attachemnts_table and the 
					# attachment is a singular (e.g. doesn't respond to .each ) so let's update
					attach = eval "obj.#{$1}.update_from_resource( resource )"
				else
					attach = Attachment.create_from_resource( resource, $1, :owner => obj )
				end
				pop_flash "There was a problem with the #{attach.name} Attachment", :error, attach unless attach.errors.empty?
			end
		end
	end
	
	
	# Controller filters -- todo -- add @current_user.validated? for filter on valid email
	def require_admin
		unless @current_user.admin?( @current_site )
			fail "Admins Only"
			return false
		end
	end
	
	def require_contributor
		unless @current_user.contributor?( @current_site )
			fail "Contributors Only"
			return false
		end
	end

	def require_login
		if @current_user.anonymous?
			fail "Please log in first", :notice
			return false
		end
	end
	
	def require_validated
		unless @current_user.validated?
			fail "Must have validated email", :notice
			return false
		end
	end
	
	def require_author_or_admin
		unless @current_author.present?
			if not @current_user.admin?( @current_site )
				fail "Must be logged in as an author", :notice
				return false
			end
		end
		@admin = @current_author.present? ? @current_author : @current_site
	end
	
	def verify_author_permissions( obj )
		return true if @current_user.admin?( @current_site )
		unless( obj.owner == @current_author )
			fail "Not your #{obj.class.to_s}", :error
			return false
		end
	end
	
	def verify_user_permissions( obj )
		return true if @current_user.admin?( @current_site )
		unless( obj.user == @current_user )
			fail "Not your #{obj.class.to_s}", :error
			return false
		end
	end
	
	# legacy -- todo replave with verify_user_permissions
	def require_user_can_manage( object )
		unless ( object.user == @current_user ) || ( @current_site.admins.include? @current_user )
			fail "Not your #{obj.class.to_s}", :error
			return false
		end
	end
	
	# sets page metadata like page title and description
	def set_meta( title, *description )
		@title = title
		@description = description.first[0..200] unless description.first.blank?
	end
	
	
	########### FAIL PAGES   ##################
	def record_not_found( exception )
		@crash = Crash.create :message => exception.to_s, :requested_url => request.url, 
						:referrer => request.env['HTTP_REFERER'], :backtrace => exception.backtrace.join("\n")
		render 'errors/not_found', :layout => 'error', :status => :not_found
	end

	def invalid_method( exception )
		@crash = Crash.create :message => exception.to_s, :requested_url => request.url, 
						:referrer => request.env['HTTP_REFERER'], :backtrace => exception.backtrace.join("\n")
		render 'errors/not_found', :layout => 'error', :status => :method_not_allowed
	end
	
	def server_error( exception )
		@crash = Crash.create :message => exception.to_s, :requested_url => request.url, 
						:referrer => request.env['HTTP_REFERER'], :backtrace => exception.backtrace.join("\n")
		render 'errors/server_error', :layout => 'error', :status => 500
	end
	

	private
	
	def fail( msg, level=:error )
		pop_flash msg, level
		redirect_to root_path
	end
	
	
end
