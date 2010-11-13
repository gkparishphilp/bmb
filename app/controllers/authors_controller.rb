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
			process_attachments_for( @author )
			pop_flash "Author Profile Created"
			redirect_to author_admin_index_path( @author )
		else
			pop_flash "Ooops, there was a problem saving the profile", :error, @author
			redirect_to :new
		end
	end
	
	def edit
		@author = Author.find params[:id]
	end
	
	def update
		@author = Author.find params[:id]
		if @author.update_attributes params[:author]
			if @author.avatar
				@author.avatar.update_from_resource( params[:attached_avatar_file] )
			else
				@author.attachments.create_from_resource( params[:attached_avatar_file], 'avatar', :owner => @author )
			end
			pop_flash "Author Profile Updated!"
		else
			pop_flash "Profile could not be saved", :error, @author
		end
		redirect_to author_admin_index_path( @author )
	end
	
	def show 
		@current_author = Author.find params[:id] if @current_author.nil?
		
		if @current_author.nil?
			pop_flash "No author found", :notice
			redirect_to root_path
		end
		
		@theme = @current_author.theme
		
	end
	
end