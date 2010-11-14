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
		@theme = @current_author.theme unless @current_author.nil? || @current_author.theme.nil?
		if @current_author.nil?
			pop_flash "No author found", :notice
			redirect_to root_path
		end
	end
	
	def bio
		@current_author = Author.find params[:id] if @current_author.nil?
		@theme = @current_author.theme unless @current_author.nil? || @current_author.theme.nil?
	end
	
	def blog
		@current_author = Author.find params[:id] if @current_author.nil?
		@theme = @current_author.theme unless @current_author.nil? || @current_author.theme.nil?
		
		if @tag = params[:tag]
            @articles = @current_author.articles.tagged_with( @tag ).published.paginate :order => "publish_on desc", :page => params[:page], :per_page => 10
		elsif @topic = params[:topic]
			@articles = @current_author.articles.tagged_with( @topic ).published.paginate :order => "publish_on desc", :page => params[:page], :per_page => 10
		elsif ( @month = params[:month] ) && ( @year = params[:year] )
			@articles = @current_author.articles.month_year( params[:month], params[:year] ).published.paginate :page => params[:page], :per_page => 10
		elsif @year = params[:year]
			@articles = @current_author.articles.year( params[:year] ).published.paginate :page => params[:page], :per_page => 10
		else
			@articles = @current_author.articles.published.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
		end
	end
	
	def books
		@current_author = Author.find params[:id] if @current_author.nil?
		@theme = @current_author.theme unless @current_author.nil? || @current_author.theme.nil?
	end
	
	def forums
		@current_author = Author.find params[:id] if @current_author.nil?
		@theme = @current_author.theme unless @current_author.nil? || @current_author.theme.nil?
	end
	
end