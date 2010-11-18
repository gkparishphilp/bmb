class EpisodesController < ApplicationController
	before_filter   :get_parent
	layout			:set_layout, :only => [ :index, :show ]
	
	def index
 		@episodes = @podcast.episodes.order 'created_at desc'
	end

	def show
		@episode = Episode.find params[:id]
		
		@commentable = @episode
		@commentable_parent = @episode.podcast
		@comment = Comment.new
		
		set_meta @episode.title, @episode.description
		
	end

	def new
		@episode = Episode.new
		render :layout => '3col'
	end

	def edit
		@episode = Episode.find params[:id]
		render :layout => '3col'
	end

	def create
		@episode = Episode.new params[:episode]
		
		if @podcast.episodes << @episode
			process_attachments_for( @episode )
			@episode.podcast.ping_itunes
			pop_flash 'Episode was successfully created.', :success

			redirect_to :back

		else
			pop_flash 'Oooops, Episode not saved...', :error, @episode
			redirect_to :back
		end
	end

	def update
		@episode = Episode.find  params[:id] 

		if @episode.update_attributes params[:episode]
			pop_flash 'Episode was successfully updated.', :success
			redirect_to :back
		else
			pop_flash 'Oooops, Episode not updated...', :error, @episode
			redirect_to :back
		end
	end
	
	def download
		@episode = Episode.find params[:id]
		send_file @episode.audio.location( nil, :full => true ), :disposition  => 'attachment', 
						:filename => @episode.title + "." + @episode.audio.format
	end

	def destroy
		@episode = Episode.find  params[:id]
		@episode.destroy
		pop_flash 'Episode was successfully deleted.'

		redirect_to :back

	end
	
private

	def get_parent
		@podcast = Podcast.find params[:podcast_id]
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	
end
