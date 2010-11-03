class BlogController < ApplicationController
	# TODO -- this requires activity plugin... also need to tweak this for author blogs rather than assuming different sites
	before_filter   :require_admin,   :except => [:index, :show]
	before_filter	:get_sidebar_data, :only => [:index, :show]
	
	def admin
		@articles = @current_site.articles.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
	end
	
	def index
		if @tag = params[:tag]
            @articles = @current_site.articles.tagged_with( @tag ).published.paginate :order => "publish_on desc", :page => params[:page], :per_page => 10
		elsif @topic = params[:topic]
			@articles = @current_site.articles.tagged_with( @topic ).published.paginate :order => "publish_on desc", :page => params[:page], :per_page => 10
		elsif ( @month = params[:month] ) && ( @year = params[:year] )
			@articles = @current_site.articles.month_year( params[:month], params[:year] ).published.paginate :page => params[:page], :per_page => 10
		elsif @year = params[:year]
			@articles = @current_site.articles.year( params[:year] ).published.paginate :page => params[:page], :per_page => 10
		else
			@articles = @current_site.articles.published.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
		end
	end


	def show
		@article = Article.find params[:id]
		
		set_meta @article.title, @article.content
		
		@comment = Comment.new
		@commentable = @article
		
		@current_user.did_read @article unless @current_user.anonymous?
		
	end

	def update
		@article = Article.find params[:id]

		if @article.update_attributes params[:article] 
			pop_flash 'Blog Post was successfully updated.'
			redirect_to admin_blog_index_path 
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

		if @current_site.articles << @article
			pop_flash 'Blog Post was successfully created.'
			@current_site.did_publish @article
			if @article.published?
				for acct in @current_site.facebook_accounts
					acct.post_feed( "#{@current_site.name} has a new post called #{@article.title}.  Check it out at #{url_for( @article )}")
				end
				for acct in @current_site.twitter_accounts
					acct.tweet( "#{@current_site.name} has a new post called #{@article.title}.", article_url( @article ) )
				end
			end
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
		redirect_to admin_blog_index_path
	end
	
private

	def get_sidebar_data
		@topics = Article.topic_counts.sort do |a, b|
			a.name <=> b.name
		end
		@archives = Article.find_by_sql( "select month(publish_on) as month, year(publish_on) as year from articles group by month(publish_on)" )
	end
	
end
