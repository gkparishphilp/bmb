module ForumsHelper

	def custom_post_link( forum, topic, post )

		if topic.nil?
			path = author_forum_topics_path( forum.owner, forum, post ) 
		else
			path = author_forum_topic_path( topic.forum.owner, topic.forum, topic )
		end

		path += "?page=" + topic.posts.last.paginated_page( topic ).to_s + 
					"#post_" + topic.posts.last.id.to_s
		return path
	end
	
	def forum_topics_link( forum )
		author_forum_topics_path( forum.owner, forum )
	end
	
	def forum_topic_link( topic )
		author_forum_topic_path( topic.forum.owner, topic.forum, topic )
	end
	
	def forums_link
		author_forums_path( @forum.owner )
	end
	
	def new_forum_topic_link( forum )
		new_author_forum_topic_path( forum.owner, forum )
	end
		
end