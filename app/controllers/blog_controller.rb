class BlogController < ApplicationController
	before_filter   :require_admin,   :except => [:index, :show]
	before_filter	:get_sidebar_data, :only => [:index, :show]
	
	def admin
		@articles = Article.all.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
	end
	
	def index
		if @tag = params[:tag]
            @articles = Article.tagged_with( @tag ).published.paginate :order => "publish_on desc", :page => params[:page], :per_page => 10
		elsif @topic = params[:topic]
			@articles = Article.tagged_with( @topic ).published.paginate :order => "publish_on desc", :page => params[:page], :per_page => 10
		elsif ( @month = params[:month] ) && ( @year = params[:year] )
			@articles = Article.month_year( params[:month], params[:year] ).published.paginate :page => params[:page], :per_page => 10
		elsif @year = params[:year]
			@articles = Article.year( params[:year] ).published.paginate :page => params[:page], :per_page => 10
		else
			@articles = Article.published.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
		end
	end


	def show
		@article = Article.find params[:id]
		
		set_meta @article.title, @article.content
		
		@comment = Comment.new
		@commentable = @article
		
	end

	def update
		@article = Article.find params[:id]

		if @article.update_attributes params[:article] 
			pop_flash 'Blog Post was successfully updated.'
			redirect_to admin_blog_path 
		else
			pop_flash 'Oooops, Blog Post not updated', :error, @article
			render :action => "edit"
		end
	end

	def new
		@article = Article.new
		@article.publish_on = Time.now
	end

	def create
		@article = Article.new params[:article]

		if @article.save
			pop_flash 'Blog Post was successfully created.'
			
			#Site.first.tweet( "New blog post: #{@article.title}. ", "http://todo.com/blog/#{@article.id}" ) unless Site.first.twitter_name.nil?
			
			redirect_to admin_blog_index_path 
		else
			pop_flash 'Oooops, Blog Post not saved', :error, @article
			render :action => "new" 
		end
	end

	def edit
		@article = Article.find params[:id]
	end

	def destroy
		@article = Article.find params[:id]
		@article.destroy
		pop_flash 'Article Nuked'
		redirect_to blog_path
	end
	
private

	def get_sidebar_data
		@topics = Article.topic_counts.sort do |a, b|
			a.name <=> b.name
		end
		@archives = Article.find_by_sql( "select month(publish_on) as month, year(publish_on) as year from articles group by month(publish_on)" )
	end
	
end
