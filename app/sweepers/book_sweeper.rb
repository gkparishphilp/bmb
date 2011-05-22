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
		expire_fragment( :controller => 'books', :action => 'show', :action_suffix => 'book_description')
		expire_fragment( "author_sku_listing_#{book.author.id}" )
		expire_fragment( "store_sku_listing_#{book.author.id}" )
	end
end
