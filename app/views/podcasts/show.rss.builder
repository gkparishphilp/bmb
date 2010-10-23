# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd", 'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title @podcast.title
	xml.copyright @copyright
    xml.description @podcast.summary
    xml.link podcast_url( @podcast )
    xml.language "en-us"

	xml.atom( :link, :href => formatted_podcast_url( @podcast, :rss ), :type => "application/rss+xml", :rel => "self" )

	xml.itunes( :author, @author.pen_name )
	xml.itunes( :summary, @podcast.summary )
	xml.itunes( :category, :text => "Arts" ) do
		xml.itunes( :category, :text => "Literature" )
	end

	xml.itunes( :explicit, @podcast.explicit )
	
	xml.itunes( :owner ) do
		xml.itunes( :name, @owner_name )
		xml.itunes( :email, @owner_email )
	end
	
	xml.itunes( :image, :href => @image_path )

    for episode in @podcast.episodes
      xml.item do
        xml.title episode.title
		
		xml.itunes( :author, @author )
		xml.itunes( :subtitle, episode.subtitle )
		xml.itunes( :summary, episode.summary )
		xml.itunes( :duration, episode.duration )
		xml.itunes( :keywords, episode.keywords )
		xml.itunes( :explicit, episode.explicit )

        xml.description episode.summary
        xml.pubDate episode.created_at.to_s( :rfc822 )
        xml.link podcast_episode_url( episode.podcast, episode )
        xml.guid podcast_episode_url( episode.podcast, episode )

		xml.enclosure :type => "audio/mpeg", :length => episode.filesize, :url => episode.url
      end
    end
  end
end