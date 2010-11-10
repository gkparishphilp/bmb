class BundleAssetsController < ApplicationController
	def new
		@bundle_asset = BundleAsset.new
	end
	
	def create
		@bundle_asset = BundleAsset.new params[:bundle_asset]
		if @bundle_asset.save
			pop_flash 'Bundle Asset saved!', 'success'
		else
			pop_flash 'Bundle Asset could not be saved.', 'error', @bundle_asset
		end
		
		redirect_to admin_authors_path
		
	end

end
