class SkuSweeper < ActionController::Caching::Sweeper
	observe Sku
	
	def after_save( sku )
		expire_cache( sku )
	end

	def after_destroy( sku )
		expire_cache( sku )
	end

	def expire_cache( sku )
		expire_fragment( :controller => 'store', :action => 'index', :action_suffix => 'sku_listing')
		expire_fragment( :controller => 'store', :action => 'show', :action_suffix => 'sku_description')
	end
end
