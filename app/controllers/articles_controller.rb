class ArticlesController < ApplicationController
	# only things we do here are create, update, and delete the resource.  Used for form paths from object name
	cache_sweeper :article_sweeper, :only => [:create, :update, :destroy]
	before_filter :get_admin
	layout '2col'
	
	def new
		@article = Article.new( :comments_allowed => true )
	end
	
	def edit
		@article = Article.find params[:id]
		verify_author_permissions( @article )
	end
	
	def create
		@article = Article.new params[:article]

		if @admin.articles << @article
			pop_flash 'Article was successfully created.'
			
			if @admin == @current_author
				redirect_to admin_blog_index_url
			else
				redirect_to blog_site_admin_index_path
			end
		else
			pop_flash 'Oooops, Article not saved...', :error, @article
			render :action => :new
		end
	end

	def update
		@article = Article.find  params[:id] 
		verify_author_permissions( @article )

		if @article.update_attributes params[:article]
			pop_flash 'Article was successfully updated.'
			
			if @admin == @current_author
				redirect_to admin_blog_index_url
			else
				redirect_to blog_site_admin_index_path
			end

		else
			pop_flash 'Oooops, Article not updated...', :error, @article
			render :action => :edit
		end
	end

	def destroy
		@article = Article.find params[:id]
		@article.destroy
		pop_flash 'Article was successfully deleted.'
		redirect_to admin_blog_index_url
	end
	
	private
	
	def get_admin
		if @current_author
			@admin = @current_author
		else
			require_admin
			@admin = @current_site
		end
	end

end
