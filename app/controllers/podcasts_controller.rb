class PodcastsController < ApplicationController
	before_filter :get_parent
	layout		:set_layout
	
	def admin
		@podcasts = @current_site.podcasts
		render :layout => '3col'
	end
	
	
	def index
		@podcasts = @owner.podcasts
	end

	def show
		@podcast = Podcast.find params[:id]
		set_meta @podcast.title, @podcast.description
	end


	def create
		@podcast = Podcast.new params[:podcast]

		if @owner.podcasts << @podcast
			process_attachments_for( @podcast )
			pop_flash 'Podcast was successfully created.'
		else
			pop_flash 'Oooops, Podcast not saved...', :error, @podcast
		end
		redirect_to :back
	end

	def update
		@podcast = Podcast.find  params[:id] 
		unless author_owns( @podcast )
			redirect_to root_path
			return false
		end
		if @podcast.update_attributes params[:podcast]
			process_attachments_for( @podcast )
			@podcast.ping_itunes
			pop_flash 'Podcast was successfully updated.'
		else
			pop_flash 'Oooops, Podcast not updated...', :error, @podcast
		end
		redirect_to :back
	end

	def destroy
		@podcast = Podcast.find params[:id]
		@podcast.destroy
		pop_flash 'Podcast was successfully deleted.'
		redirect_to :back
	end
	
private 

	def get_parent
		@owner = @author ? @author : @current_site
	end 
	
	
	def get_sidebar_data
		# TODO
	end
	
	def set_layout
		@author ? "authors" : "application"
	end


end
