class PodcastsController < ApplicationController
	# TODO - cleanup for author podcasts
	def admin
		@podcasts = @current_site.podcasts
	end
	
	
	def index
		@podcasts = @current_site.podcasts
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

		if @current_site.podcasts << @podcast
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

	def get_parent
		@owner = params[:author_id] ? Author.find params[:author_id] : @current_site
	end 
	
	
	def get_sidebar_data
		# TODO
	end
	
	def set_layout
		@author ? "authors" : "application"
	end


end
