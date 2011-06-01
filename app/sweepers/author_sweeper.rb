class AuthorSweeper < ActionController::Caching::Sweeper
	observe Author
	
	def after_save( author )
		expire_cache( author )
	end
	
	def after_update( author )
		expire_cache( author )
	end

	def after_destroy( author )
		expire_cache( author )
	end

	def expire_cache( author )
		expire_fragment( "store_sku_listing_#{author.id}" )
		expire_fragment( "author_sku_listing_#{author.id}")
	end
	
end