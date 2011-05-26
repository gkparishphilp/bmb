class SkusController < ApplicationController
	cache_sweeper :sku_sweeper, :only => [:create, :update, :destroy, :update_sort]
	before_filter :get_items, :only => [:edit, :manage_items]

	def create
		@sku = Sku.new params[:sku]

		@sku.price = params[:sku][:price].to_f * 100 if params[:sku][:price]
		@sku.domestic_shipping_price = params[:sku][:domestic_shipping_price].to_f * 100 if params[:sku][:domestic_shipping_price]
		@sku.international_shipping_price = params[:sku][:international_shipping_price].to_f * 100 if params[:sku][:international_shipping_price]
		
		if @current_author.skus << @sku
			process_attachments_for @sku
			pop_flash 'Sku saved!'
			redirect_to manage_items_author_sku_path( @current_author, @sku)
		else
			pop_flash 'Sku could not be saved.', :error, @sku
			redirect_to edit_author_sku_path( @current_author, @sku )
		end
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
		redirect_to listing_author_skus_path(@current_author)
	end
	
	def show
		@sku = Sku.find params[:id]
		render :layout => 'authors'
	end
	
	def manage_items
		@sku = Sku.find params[:id]
		unless @sku.owner == @current_author
			pop_flash 'You do not own this SKU', :error
			redirect_to root_path
			return false
		end
		render :layout => '3col'
	end
	
	def edit
		@sku = Sku.find params[:id]
		unless @sku.owner == @current_author
			pop_flash 'You do not own this SKU', :error
			redirect_to root_path
			return false
		end
		render :layout => '3col'
	end
	
	def new
		@sku = Sku.new
		@books = @current_author.books
		render :layout => '3col'
	end
	
	def sort
		@skus = @current_author.skus.published.order( 'listing_order asc' )
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
	
	def remove_item
		@sku = Sku.find params[:id]
		@item = SkuItem.find_by_sku_id_and_item_id_and_item_type(@sku.id, params[:item_id], params[:item_type] )
		if @sku.remove_item( @item )
			pop_flash "Item removed"
		else
			pop_flash "Could not remove item", :error
		end
		redirect_to :back
			 
	end
	
	def listing
		render :layout => '2col'
	end

	protected
	
	def get_items
		@books = @current_author.books
		@items = @current_author.merches.published.map{ |m| [ "#{m.title} (#{m.class.name})", "#{m.class.name}_#{m.id}"] }
		@items += @current_author.published_assets.map{ |a| [ "#{a.title} (#{a.class.name})", "#{a.class.name}_#{a.id}"] }
	end
end
