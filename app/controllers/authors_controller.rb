class AuthorsController < ApplicationController
	before_filter	:require_login, :except => [ :index, :show ]
	
	def index
	end

	def manage
		@author = @current_user.author
		@campaign = @author.email_campaigns.find_by_title('Default')
		@all_assets = Array.new
		for book in @author.books
			for asset in book.assets
				@all_assets << asset
			end
		end
	end
	
	def new
		if @current_user.author?
			pop_flash "Already an Author", :notice
			redirect_to author_admin_index_path( @current_user.author ) 
		end
		@author = Author.new
		@author.pen_name = @current_user.name
		@author.bio = @current_user.bio
	
	end
	
	def create
		@author = Author.new params[:author]
		@author.user = @current_user
		if @author.save
			pop_flash "Author Profile Created"
			redirect_to author_admin_index_path( @author )
		else
			pop_flash "Ooops, there was a problem saving the profile", :error, @author
			redirect_to :new
		end
	end
	
	def show 
		@current_author = Author.find params[:id] if @current_author.nil?
		if @current_author.nil?
			pop_flash "No author found", :notice
			redirect_to root_path
		end
	end
	
end