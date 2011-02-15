class ActivitySweeper < ActionController::Caching::Sweeper
	observe Activity
	
	def after_save( activity )
		expire_cache( activity )
	end

	def after_destroy( activity )
		expire_cache( activity )
	end

	def expire_cache( activity )
		expire_fragment( :controller => 'site', :action => 'index', :action_suffix => 'activity_feed')
		expire_fragment( :controller => 'authors', :action => 'show', :action_suffix => 'activity_feed')
		
	end
	
end