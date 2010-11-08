class AuthorsController < ApplicationController
	before_filter	:require_login, :except => [ :index, :show ]
	
	def index
	end

	def admin
		@author = @current_user.author
		@campaign = @author.email_campaigns.find_by_title('Default')
	end
	
	def new
		@author = Author.new
		@author.pen_name = @current_user.name
		@author.bio = @current_user.bio
		redirect_to admin_authors_path if @current_user.author?
	end
	
	def create
		@author = Author.new params[:author]
		@author.user = @current_user
		if @author.save
			pop_flash "Author Profile Created"
			redirect_to admin_authors_path
		else
			pop_flash "Ooops, there was a problem saving the profile", :error, @author
			redirect_to :new
		end
	end
	
	def show 
		if request.subdomain.present? && !APP_SUBDOMAINS.include?( request.subdomain )
			@author = Author.find_by_subdomain request.subdomain
		else
			@author = Author.find params[:id]
		end
	end
	
end