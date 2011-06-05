class BookSweeper < ActionController::Caching::Sweeper
	observe Book
	
	def after_save( book )
		expire_cache( book )
	end

	def after_update( book )
		expire_cache( book )
	end

	def after_destroy( book )
		expire_cache( book )
	end

	def expire_cache( book )
		expire_fragment( "book_description_#{book.author.id}_#{book.id}")
		expire_fragment( "author_sku_listing_#{book.author.id}" )
		expire_fragment( "store_sku_listing_#{book.author.id}" )
	end
end
