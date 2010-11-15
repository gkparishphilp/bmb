class AdminController < ApplicationController
	# for author admin
	before_filter :require_author # make sure @current_user is an author and punt if not
	
	def design
		@edit_theme = @current_author.theme || Theme.new
	end
	
	def books
		
	end
	
	def blog
		@article = params[:article_id] ? ( Article.find params[:article_id] ) : Article.new
		@articles = @current_author.articles.recent
	end

	
end
