class MerchObserver < ActiveRecord::Observer
	# Need this observer instead of a sweeper because merch inventory count gets updated by the sku model directly, and not through the merch_controller.  
	# Therefore, the merch sweeper is not activated to clear out merch.inventory display in the cached sku_listing fragment when an order is made. 
	
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
