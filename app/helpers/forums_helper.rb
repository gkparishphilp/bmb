module ForumsHelper

	def custom_post_path( forum, topic, post )
			path = ""
			if topic.nil?
				path = forum_topic_path(forum, post)
			else
				path = forum_topic_path(forum, topic) + 
				"?page=" + topic.posts.last.paginated_page(topic).to_s + 
				"#post_" + topic.posts.last.id.to_s
			end
			path
		end
		
end