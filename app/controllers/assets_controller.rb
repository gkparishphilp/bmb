class AssetsController < ApplicationController
	before_filter   :get_parent
	layout			'3col'
	
	def new
		@asset = Asset.new
	end
	
	def edit
		@asset = Asset.find params[:id]
	end
	
	def create
		@asset = Asset.new params[:asset]
		if @asset.save
			process_attachments_for( @asset )
			pop_flash 'Asset saved!', 'success'
		else
			pop_flash 'Asset could not be saved.', :error, @asset
		end

		redirect_to :back

	end
	
	def update
		@asset = Asset.find params[:id]
		
		if @asset.update_attributes params[:asset]
			process_attachments_for( @asset )
			pop_flash 'Asset saved!', 'success'
		else
			pop_flash 'Asset could not be saved.', :error, @asset
		end

		redirect_to :back
		
	end
	
	private
	
	def get_parent
		@book = Book.find params[:book_id]
	end

end