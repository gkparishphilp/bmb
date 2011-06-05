class BlogController < ApplicationController
	# owner is to set the display properly -- use author template when author_id
	# use site template otherwise
	before_filter	:get_owner, :get_sidebar_data	
	# admin is the person who can administer the blog.  Set to @current_author if there
	# is one, otherwise site admin
	before_filter	:get_admin, :only => :admin
	before_filter	:check_permissions, :only => [:admin, :new, :edit]
	
	helper_method	:sort_column, :sort_dir
	
	layout			:set_layout
	
	def admin
		@articles = @admin.articles.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		render :layout => '2col'
	end

	def index
		if @tag = params[:tag]
            @articles = @owner.articles.tagged_with( @tag ).published.order( "publish_at desc" ).paginate( :page => params[:page], :per_page => 10 )
		elsif @topic = params[:topic]
			@articles = @owner.articles.tagged_with( @topic ).published.order( "publish_at desc" ).paginate( :page => params[:page], :per_page => 10 )
		elsif ( @month = params[:month] ) && ( @year = params[:year] )
			@articles = @owner.articles.month_year( params[:month], params[:year] ).published.order( "publish_at desc" ).paginate( :page => params[:page], :per_page => 10 )
		elsif @year = params[:year]
			@articles = @owner.articles.year( params[:year] ).published.order( "publish_at desc" ).paginate( :page => params[:page], :per_page => 10 )
		else
			@articles = @owner.articles.published.order( 'publish_at desc' ).paginate( :page => params[:page], :per_page => 10 )
		end
	end
	
	def new
		@article = Article.new
		render :layout => '2col'
	end
	
	def edit
		@article = @current_author.articles.find( params[:id] )
		render :layout => '2col'
	end


	def show
		@article = Article.find params[:id]
		
		set_meta @article.title, @article.content
		
		@comment = Comment.new
		@commentable = @article
		
		@current_user.did_read @article unless @current_user.anonymous?
		@article.raw_stats.create :name =>'view', :ip => request.ip 		
	end


private

	def get_owner
		@owner = @current_author ? @current_author : @author 
	end
	
	def get_admin
		@admin = @current_author ? @current_author : @current_site
		require_contributor if @admin == @current_site
	end
	
	def sort_column
		Article.column_names.include?( params[:sort] ) ? params[:sort] : 'publish_at'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end

	def get_sidebar_data
		@topics = @owner.articles.topic_counts.sort do |a, b|
			a.name <=> b.name
		end
		@recent_posts = @owner.articles.recent.published[0..9]
		@archives = Article.find_by_sql( [ "select month(publish_at) as month, year(publish_at) as year from articles where owner_id = ? and owner_type = ?  group by month(publish_at) ", @owner.id, @owner.class.name ] )
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	
	def check_permissions
		unless @admin.has_valid_subscription?( Subscription.first)
			pop_flash "Update to the Author Platform Builder Account to access this feature!", :error
			redirect_to admin_index_path
		end
	end

	
	
end
