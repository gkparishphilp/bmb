class SiteAdminController < ApplicationController
	# for managing the site - blog posts, customer service, etc.
	
	layout '2col'
	# make sure @current_user is an author or admin -- set @admin = @current_site or @admin
	before_filter	:require_admin 
	helper_method	:sort_column, :sort_dir
	
	def index
		@authors = Author.order('created_at desc').limit(5)
		@orders = Order.successful.order('created_at desc').dated_between(Time.now.beginning_of_day.getutc, Time.now.getutc)
	end
	
	def blog
		@article = Article.new
		@articles = @current_site.articles.order( 'publish_at desc' ).paginate( :per_page => 50, :page => params[:page] )
	end
	
	def author
		if params[:email]
			@user = User.find_by_email( params[:email] )
		end
		@authors = Author.order('created_at desc')
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
		if params[:filter] == 'published'
			@comments = Comment.published.order( 'created_at desc' ).paginate(:per_page => 50, :page => params[:page])
		else
			@comments = Comment.order( 'created_at desc' ).paginate(:per_page => 50, :page => params[:page])
		end
		render :layout => '2col'
	end

	def spam
		@filters = SpamFilter.order("filter_type desc")
	end
	
end


