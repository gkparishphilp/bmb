class BookSweeper < ActionController::Caching::Sweeper
	observe Book
	
	def after_save( book )
		expire_cache( book )
	end

	def after_destroy( book )
		expire_cache( book )
	end

	def expire_cache( book )
		expire_fragment( :controller => 'books', :action => 'index')
	end
end
