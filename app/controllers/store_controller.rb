class StoreController < ApplicationController
	# going to use to show store page -- list of skus, and store/show/id for sku detail
	layout 'authors'
	
	def index
		@skus = @author.skus
	end
	
	def show
		@sku = Sku.find params[:id]
		@reviewable = @sku.merches.first if @sku.merch_sku?
	end
	
end
