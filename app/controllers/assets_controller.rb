class AssetsController < ApplicationController
	def new
		@asset = Asset.new
	end
	
	def create
		@asset = Asset.new params[:asset]
		if @asset.save
			pop_flash 'Asset saved!', 'success'
		else
			pop_flash 'Asset could not be saved.', 'error', @asset
		end
		
		redirect_to admin_authors_path

	end

end