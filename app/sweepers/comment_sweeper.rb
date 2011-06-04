class CommentSweeper < ActionController::Caching::Sweeper
	observe Comment
	
	def after_save( comment )
		expire_cache( comment )
	end
	
	def after_update( comment )
		expire_cache( comment )
	end

	def after_destroy( comment )
		expire_cache( comment )
	end

	def expire_cache( comment )
		if comment.commentable.is_a? Article
			expire_fragment( "blog_index_#{comment.commentable.owner.class.name}_#{comment.commentable.owner.id}" )
			expire_fragment( "blog_article_#{comment.commentable.owner.class.name}_#{comment.commentable.owner.id}_#{comment.commentable.id}")
		end
	end
	
end