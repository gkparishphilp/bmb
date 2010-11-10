class BundlesController < ApplicationController
	def new
		@bundle = Bundle.new
	end
	
	def create
		@bundle = Bundle.new params[:bundle]
		if @bundle.save
			pop_flash 'Bundle saved!', 'success'
		else
			pop_flash 'Bundle could not be saved.', 'error', @bundle
		end
		
		redirect_to admin_authors_path
	end

end
