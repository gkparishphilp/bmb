class ArticleSweeper < ActionController::Caching::Sweeper
	observe Article
	
	def after_save( article )
		expire_cache( article )
	end
	
	def after_update( article )
		expire_cache( article )
	end

	def after_destroy( article )
		expire_cache( article )
	end

	def expire_cache( article )
		expire_fragment( "blog_index_#{article.owner.class.name}_#{article.owner.id}" )
		expire_fragment( "blog_article_#{article.owner.class.name}_#{article.owner.id}_#{article.id}")
		
	end
	
end