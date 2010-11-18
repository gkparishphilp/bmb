module PodcastHelper
	def podcast_link( podcast )
		if podcast.owner.is_a? Author
			author_podcast_path( podcast.owner, podcast )
		else
			podcast_path( podcast )
		end
	end
	
	def episode_link( episode )
		if episode.podcast.owner.is_a? Author
			author_podcast_episode_path( episode.podcast.owner, episode.podcast, episode )
		else
			podcast_episode_path( episode.podcast, episode )
		end
	end
	
	def podcast_index_link( args={} )
		if @author
			author_podcast_index_path( @author, args )
		else
			podcast_index_path( args )
		end
	end
	
end