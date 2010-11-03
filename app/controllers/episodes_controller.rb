class EpisodesController < ApplicationController
	# TODO -- needs significant cleanup
	before_filter   :get_parent
	
	def index
 		@episodes = @podcast.episodes.order 'created_at desc'
	end

	def show
		@episode = Episode.find  params[:id]
		
		@commentable = @episode
		@commentable_parent = @episode.podcast
		@comment = Comment.new
		
		set_meta @episode.title, @episode.summary
		
	end

	def new
		@episode = Episode.new
	end

	def edit
		@episode = Episode.find  params[:id]
	end

	def create
		@episode = Episode.new params[:episode]
		
		if params[:upload_file].nil?
			pop_flash "Ooops, you forgot your audio file.", :error
			render :new
			return false
		end
		
		# validate filetype (mp3)
		extension = params[:upload_file].original_filename.match( /\.\w*$/ ).to_s # a period, any number of word chars, then eol
		unless [ '.mp3', '.aac' ].include? extension.downcase
			pop_flash "Only MP3 and AAC files are allowed: you gave me #{extension}", 'error'
			render :new
			return false
		end
		
		# todo - move episode saving stuff to model like upload_file
		
		if @podcast.episodes << @episode
			filename = params[:upload_file]
			
			directory = "#{RAILS_ROOT}/public/system/audio/podcasts/#{@podcast.id}/"

			Dir.mkdir( directory ) unless File.exists? directory
			
			directory += "#{@episode.id}"
			
			Dir.mkdir( directory ) unless File.exists? directory
			name = @episode.friendly_id + extension
			path = File.join( directory, name )
			post = File.open( path,"wb" ) { |f| f.write( filename.read ) }

			filesize = File.size( path )
			
			@episode.update_attributes :filename => path, :filesize => filesize
			
			@episode.podcast.ping_itunes 
			
			pop_flash 'Episode was successfully created.', :success

			redirect_to podcast_episode_path( @podcast, @episode )

		else
			pop_flash 'Oooops, Episode not saved...', :error, @episode
			render :action => :new
		end
	end

	def update
		@episode = Episode.find  params[:id] 
		
		unless params[:upload_file].blank?
			filename = params[:upload_file]
			extension = params[:upload_file].original_filename.match( /\.\w*$/ ).to_s # a period, any number of word chars, then eol
			unless [ '.mp3', '.aac' ].include? extension.downcase
				pop_flash "Only MP3 and AAC files are allowed: you gave me #{extension}", 'error'
				render :edit
				return false
			end
			
			# delete the old episode
			if File.exists?( @episode.filename )
				FileUtils.rm_r( @episode.filename )
			end
			# write the new upload
			post = File.open( @episode.filename,"wb" ) { |f| f.write( filename.read ) }
			filesize = File.size( @episode.filename )
			@episode.update_attributes :filesize => filesize
		end

		if @episode.update_attributes(params[:episode])
			pop_flash 'Episode was successfully updated.', :success
			redirect_to podcast_episode_path( @podcast, @episode )
		else
			pop_flash 'Oooops, Episode not updated...', :error, @episode
			render :action => :edit
		end
	end
	
	def download
		@episode = Episode.find params[:id]
		send_file @episode.filename, :disposition  => 'attachment', :filename => @episode.title + ".mp3"
	end

	def destroy
		@episode = Episode.find  params[:id]
		# actually delete episode file
		directory = "#{RAILS_ROOT}/public/system/audio/podcasts/#{@episode.podcast.id}/#{@episode.id}"
		if File.exists?( directory )
			FileUtils.rm_r( directory )
		end
		@episode.destroy
		pop_flash 'Episode was successfully deleted.', :success

		redirect_to podcast_episode_path( @podcast, @episode )

	end
	
private

	def get_parent
		@podcast = Podcast.find params[:podcast_id] if params[:podcast_id]
	end
	
end
