class SitesController < ApplicationController
	#before_filter	:require_admin, :except => :index
	layout 'home', :only => :index
	
	def new
		@site = Site.new
		@site.name = "#{@current_author.pen_name} Site"
		# require subscription author
		render :layout => '3col'
	end
	
	def edit
		@site = Site.find params[:id]
		# require author_owns @site
		render :layout => '3col'
	end
	
	def create
		@site = Site.new params[:site]
		if @current_author.sites << @site
			pop_flash "Domain Added"
		else
			pop_flash "Domain could not be added", @site
		end
		redirect_to :back
	end
	
	def update
		@site = Site.find params[:id] 
		if @site.update_attributes params[:site]
			pop_flash "Domain Updated"
		else
			pop_flash "Domain coudl not be updated", @site
		end
		redirect_to :back
	end
	
	def index
		@activities = Activity.feed @current_site.users, @current_site
	end
	
end