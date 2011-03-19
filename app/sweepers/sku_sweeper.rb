class SkuSweeper < ActionController::Caching::Sweeper
	observe Sku
	
	def after_save( sku )
		expire_cache( sku )
	end

	def after_destroy( sku )
		expire_cache( sku )
	end
	
	def after_update( sku )
		expire_cache( sku )
	end

	def expire_cache( sku )
		expire_fragment( "author_sku_listing_#{sku.owner.id}" )
		expire_fragment( "store_sku_listing_#{sku.owner.id}" )
	end
end
