class SitesController < ApplicationController
	#before_filter	:require_admin, :except => :index
	layout 'home', :only => :index
	
	def new
		@site = Site.new
		@site.name = "#{@current_author.pen_name} Site"
		# require subscription author
		render :layout => '2col'
	end
	
	def edit
		@site = Site.find params[:id]
		unless author_owns( @asset )
			redirect_to root_path
			return false
		end
		render :layout => '2col'
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
		unless author_owns( @asset )
			redirect_to root_path
			return false
		end
		if @site.update_attributes params[:site]
			pop_flash "Domain Updated"
		else
			pop_flash "Domain could not be updated", @site
		end
		redirect_to :back
	end
	
	def index
				
		@recent_blog_posts = @current_site.articles.empty? ? [] : ( @current_site.articles.order( "publish_at desc" ).limit( 5 ) )
		@recent_episodes = @current_site.podcasts.empty? ? [] : ( @current_site.podcasts.first.episodes.order( "created_at desc" ).limit( 5 ) )

		@items = @recent_blog_posts + @recent_episodes
		@items = @items.sort { |a,b| b.created_at <=> a.created_at }
		
		set_meta "Home"
		
	end
	
end