class AdminController < ApplicationController
	# for author admin
	before_filter :require_author # sets @current_author to @currnet_user.author and punts if @current_user not an author
	
	
	def design
		@edit_theme = @author.theme || Theme.new
	end
	
	def create
		redirect_to :index
	end
	
end
