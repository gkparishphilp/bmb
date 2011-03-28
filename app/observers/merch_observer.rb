class MerchObserver < ActiveRecord::Observer
	observe Merch
	
	def after_save( merch )
		expire_cache( merch )
	end

	def after_destroy( merch )
		expire_cache( merch )
	end
	
	def after_update( merch )
		expire_cache( merch )
	end

	def expire_cache( merch )
		for sku in merch.skus
			ActionController::Base.new.expire_fragment( "author_sku_listing_#{sku.owner.id}" )
			ActionController::Base.new.expire_fragment( "store_sku_listing_#{sku.owner.id}" )
		end
	end
end
