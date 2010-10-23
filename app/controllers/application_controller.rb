class ApplicationController < ActionController::Base
	protect_from_forgery
	before_filter :fetch_logged_in_user


protected
	
	def fetch_logged_in_user
		@current_user = (session[:user_id] && User.find(session[:user_id])) || User.anonymous
		@current_user.human = @current_user.logged_in? || cookies[:human] == 'true'
	end
	
	def pop_flash( message, code = :success, *object )
		flash[code] = "<b>#{message}</b>"
		
		object.each do |obj|
			obj.errors.each do |field, msg|
				flash[code] += "<br>" + field.to_s + ": " if field
				flash[code] += " " + msg 
			end
		end
	end
	
	def require_admin
		if @current_user.anonymous?
			flash[:notice] = "Please log in first"
			redirect_to new_session_path
			return false
		else
			unless @current_user.admin?
				flash[:notice] = "Admins Only"
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
		unless object.user == @current_user
			pop_flash "Not your #{object.class.to_s}", :error
			redirect_to root_path
			return false
		end
	end
	
	def set_meta( title, *description )
		@title = title
		@description = description.first[0..200] unless description.first.blank?
	end
	
end
