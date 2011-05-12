class SkusController < ApplicationController
	cache_sweeper :sku_sweeper, :only => [:create, :update, :destroy, :update_sort]

	def create
		@sku = Sku.new params[:sku]

		@sku.price = params[:sku][:price].to_f * 100 if params[:sku][:price]
		@sku.domestic_shipping_price = params[:sku][:domestic_shipping_price].to_f * 100 if params[:sku][:domestic_shipping_price]
		@sku.international_shipping_price = params[:sku][:international_shipping_price].to_f * 100 if params[:sku][:international_shipping_price]
		
		if @current_author.skus << @sku
			process_attachments_for @sku
			pop_flash 'Sku saved!'
		else
			pop_flash 'Sku could not be saved.', :error, @sku
		end
		redirect_to :back
	end
	
	def update
		@sku = Sku.find params[:id]

		params[:sku][:price] = params[:sku][:price].to_f * 100 if params[:sku][:price]
		params[:sku][:domestic_shipping_price] = params[:sku][:domestic_shipping_price].to_f * 100 if params[:sku][:domestic_shipping_price]
		params[:sku][:international_shipping_price] = params[:sku][:international_shipping_price].to_f * 100 if params[:sku][:international_shipping_price]

		unless @sku.owner == @current_author
			pop_flash 'You do not own this SKU', :error
			redirect_to root_path
			return false
		end
		if @sku.update_attributes params[:sku]
			process_attachments_for @sku
			pop_flash 'Sku saved!'
		else
			pop_flash 'Sku could not be saved.', :error, @sku
		end
		redirect_to :back
	end
	
	def show
		@sku = Sku.find params[:id]
		render :layout => 'authors'
	end
	
	def edit
		@sku = Sku.find params[:id]
		unless @sku.owner == @current_author
			pop_flash 'You do not own this SKU', :error
			redirect_to root_path
			return false
		end
		@books = @current_author.books
		@items = @current_author.merches.map{ |m| [ "#{m.title} (#{m.class.name})", "#{m.class.name}_#{m.id}"] }
		@items += @current_author.assets.map{ |a| [ "#{a.title} (#{a.class.name})", "#{a.class.name}_#{a.id}"] }
		render :layout => '3col'
	end
	
	def new
		@sku = Sku.new
		@books = @current_author.books
		render :layout => '3col'
	end
	
	def sort
		@skus = @current_author.skus.order( 'listing_order asc' )
		render :layout => '3col'
	end
	
	def update_sort
		ids = params[:newOrder].split(/,/).collect{ |elem| elem.split(/_/).last }
		for id in ids
			sku = Sku.find( id )
			sku.update_attributes( :listing_order => ids.index( id ) )
		end
		redirect_to sort_author_skus_path( @current_author )
	end
	
	def add_item
		@sku = Sku.find params[:id]
		type, id = params[:sku][:item].split(/_/)
		# let's go Meta, Baby!!!
		@item = eval "#{type}.find #{id}"
		if @sku_item = @sku.add_item( @item )
			pop_flash "Item Added!"
		else
			pop_flash "Couldn't Add Item", :error, @sku_item
		end
		redirect_to :back
	end

end
