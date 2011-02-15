class ArticleSweeper < ActionController::Caching::Sweeper
	observe Article
	
	def after_save( activity )
		expire_cache( activity )
	end

	def after_destroy( activity )
		expire_cache( activity )
	end

	def expire_cache( activity )
		expire_fragment( :controller => 'site', :action => 'index', :action_suffix => 'left')
	end
	
end