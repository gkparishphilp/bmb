class SiteAdminController < ApplicationController
	# for managing the site - blog posts, customer service, etc.
	
	layout '2col'
	# make sure @current_user is an author or admin -- set @admin = @current_site or @admin
	before_filter	:require_admin 
	helper_method	:sort_column, :sort_dir
	
	def index
		
	end
	
	def blog
		@article = Article.new
		@articles = @current_site.articles.search( params[:q] ).order( 'publish_at desc' ).paginate( :per_page => 5, :page => params[:page] )
	end
	
	def new_blog
		@article = Site.first.articles.new
		@admin = @current_site
	end
	
	def edit_blog
		@article = Article.find( params[:article_id] )
		@admin = @current_site
	end
	
	def users
		@users = User.order( 'created_at desc' ).limit( 50 )
	end
	
	def comments
		@comments = Comment.all.paginate(:per_page => 10, :page => params[:page])
		render :layout => '2col'
	end

	
end


