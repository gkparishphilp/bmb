class AdminController < ApplicationController
	# for author admin
	layout '3col'
	before_filter :require_author # make sure @current_user is an author and punt if not
	
	def design
		@edit_theme = @current_author.theme || Theme.new
	end
	
	def books
		@books = @current_author.books
	end
	
	def blog
		@article = params[:article_id] ? ( Article.find params[:article_id] ) : Article.new
		@articles = @current_author.articles.recent
	end
	
	def forums
		@forum = params[:forum_id] ? ( Forum.find params[:forum_id] ) : Forum.new
		@forums = @current_author.forums
	end

	
end
