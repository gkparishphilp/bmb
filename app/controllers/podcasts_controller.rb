class PodcastsController < ApplicationController
	before_filter	:get_owner
	
	def admin
		if @owner
			@podcasts = @owner.podcasts
		else
			@podcasts = Podcast.all
		end
	end
	
	
	def index
		if @owner
			@podcasts = @owner.podcasts
		else
 			@podcasts = Podcast.all
		end
	end

	def show
		@podcast = Podcast.find params[:id]
		set_meta @podcast.title, @podcast.summary
	end

	def new
		@podcast = Podcast.new
	end

	def edit
		@podcast = Podcast.find  params[:id]
	end

	def create
		@podcast = Podcast.new params[:podcast]
		# todo - won't always work -- unless podcast is always a nested resource
		if @owner.podcasts << @podcast
			pop_flash 'Podcast was successfully created.'
			redirect_to @podcast
		else
			pop_flash 'Oooops, Podcast not saved...', :error, @podcast
			render :action => :new
		end
	end

	def update
		@podcast = Podcast.find  params[:id] 

		if @podcast.update_attributes params[:podcast]
			@podcast.ping_itunes
			pop_flash 'Podcast was successfully updated.'
			redirect_to @podcast
		else
			pop_flash 'Oooops, Podcast not updated...', :error, @podcast
			render :action => :edit
		end
	end

	def destroy
		@podcast = Podcast.find params[:id]
		@podcast.destroy
		pop_flash 'Podcast was successfully deleted.'
		redirect_to podcasts_url
	end
	
private
	
	def get_owner
		@owner = Site.find params[:site_id] if params[:site_id]
    end


end
