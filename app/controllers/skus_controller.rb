class SkusController < ApplicationController
	def new
		@sku = Sku.new
	end
	
	def create
		@sku = Sku.new params[:sku]
		if @sku.save
			pop_flash 'Sku saved!', 'success'
		else
			pop_flash 'Sku could not be saved.', 'error', @sku
		end
		
		redirect_to admin_authors_path
	end

end
