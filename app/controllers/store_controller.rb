class StoreController < ApplicationController
	# going to use to show store page -- list of skus, and store/show/id for sku detail
	layout 'authors'
	
	def admin
		@skus = @current_author.skus.order( 'listing_order asc' )
		render :layout => '2col'
	end
	
	def promo
		render :layout => '2col'
	end
	
	def faq
		@faq = @current_author.faq
		render :layout => '2col'
	end
	
	def index
		@skus = @author.skus.order( 'listing_order asc' )
	end
	
	def show
		@sku = Sku.find params[:id]
		if @sku.published?
			@reviewable = @sku.merches.first if @sku.merch_sku?
		else
			pop_flash "Sorry, that item is not available.", :error
			redirect_to author_path( @author )
		end
	end
	
end
