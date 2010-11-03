class SiteController < ApplicationController
	before_filter	:require_admin, :except => :index
	
	def admin
		
	end
	
	def index
		@activities = Activity.feed @current_site.users, @current_site
	end
	
end