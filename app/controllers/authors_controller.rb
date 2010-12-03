class AuthorsController < ApplicationController
	before_filter	:require_login, :except => [ :index, :show, :bio ]
	
	def index
		@author = Author.last
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
			redirect_to admin_index_path
			return false
		end
		@author = Author.new
		@author.pen_name = @current_user.name
		@author.bio = @current_user.bio
		render :layout => 'application'
	end
	
	def create
		@author = Author.new params[:author]
		@author.user = @current_user
		if @author.save
			process_attachments_for( @author )
			pop_flash "Author Profile Created"
			redirect_to admin_index_path
		else
			pop_flash "Ooops, there was a problem saving the profile", :error, @author
			redirect_to :new
		end
	end
	
	def edit
		@author = @current_author
	end
	
	def update
		@author = Author.find params[:id]
		unless author_owns( @author )
			redirect_to root_path
			return false
		end
		if @author.update_attributes params[:author]
			process_attachments_for( @author )
			pop_flash "Author Profile Updated!"
		else
			pop_flash "Profile could not be saved", :error, @author
		end
		redirect_to admin_index_path
	end
	
	def show 
		@author = Author.find params[:id] if @author.nil?
		
		set_meta @author.pen_name, @author.bio
		
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
		if @author.nil?
			pop_flash "No author found", :notice
			redirect_to root_path
		end
		
	end
	
	def bio
		@author = Author.find params[:id] if @author.nil?
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
	end
	
	def help
		@author = Author.find params[:id] if @author.nil?
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
	end
	
	
	
end