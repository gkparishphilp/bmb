module ForumsHelper

	def custom_post_path( forum, topic, post )

		return forum_topic_path( forum, post ) if topic.nil?
		
		if forum.owner.is_a? Author
			path = author_forum_topic_path( forum.owner, forum, topic )
		else
			path = forum_topic_path( forum, topic )
		end

		path += "?page=" + topic.posts.last.paginated_page( topic ).to_s + 
					"#post_" + topic.posts.last.id.to_s
		return path
	end
	
	def forum_topics_link( forum )
		if forum.owner.is_a? Author
			author_forum_topics_path( forum.owner, forum )
		else
			fourm_topics_path( forum )
		end
	end
	
	def forum_topic_link( topic )
		if topic.forum.owner.is_a? Author
			author_forum_topic_path( topic.forum.owner, topic.forum, topic )
		else
			forum_topic_path( topic.forum, topic )
		end
	end
	
	def forums_link
		if @forum.owner.is_a? Author
			author_forums_path( @forum.owner )
		else
			forums_path
		end
	end
	
	def new_forum_topic_link( forum )
		if forum.owner.is_a? Author
			new_author_forum_topic_path( forum.owner, forum )
		else
			new_forum_topic_path( forum )
		end
	end
		
end