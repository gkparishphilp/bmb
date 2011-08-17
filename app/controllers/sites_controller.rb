class SitesController < ApplicationController
	#before_filter	:require_admin, :except => :index
	layout 'home', :only => [ :index, :thank_you ]
	
	def admin
		@site = @current_author.sites.first
		@site ||= @current_author.sites.new :name => "#{@current_author.pen_name} Site"
		render :layout => '2col'
	end
	
	def new
		@site = Site.new
		@site.name = "#{@current_author.pen_name} Site"
		# require subscription author
		render :layout => '2col'
	end
	
	def newsletter_signup
		
		user = User.find_or_initialize_by_email( params[:email] )
		user.name = params[:name].gsub( /\W/, "_" )

		if user.save
			subscribing = EmailSubscribing.find_or_create_subscription( @current_site, user)  
			subscribing.update_attributes :status => 'subscribed' 
		else
			pop_flash 'There was an error: ', :error, user
			redirect_to :back
			return false
		end
		
		pop_flash "Thank you for signing up for the BackMyBook newsletter!"
		redirect_to thank_you_path
		
	end
	
	def thank_you
		@recent_blog_posts = @current_site.articles.published.empty? ? [] : ( @current_site.articles.published.order( "publish_at desc" ).limit( 5 ) )
	end
	
	def edit
		@site = Site.find params[:id]
		unless @site.author == @current_author
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
		unless @site.author == @current_author
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
				
		@recent_blog_posts = @current_site.articles.published.empty? ? [] : ( @current_site.articles.published.order( "publish_at desc" ).limit( 5 ) )
		@recent_episodes = @current_site.podcasts.empty? ? [] : ( @current_site.podcasts.first.episodes.order( "created_at desc" ).limit( 5 ) )

		@items = @recent_blog_posts + @recent_episodes
		@items = @items.sort { |a,b| b.created_at <=> a.created_at }
		
		set_meta "Home"
		
	end
	
end