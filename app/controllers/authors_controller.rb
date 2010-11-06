class AuthorsController < ApplicationController
	
	def index
	end

	def admin
		@author = @current_user.author
		@campaign = @author.email_campaigns.find_by_title('Default')
	end
end