class SkusController < ApplicationController
	cache_sweeper :sku_sweeper, :only => [:create, :update, :destroy, :update_sort]


	def create
		@sku = Sku.new( params[:sku] )

		@sku.price = params[:sku][:price].to_f * 100 if params[:sku][:price]
		@sku.domestic_shipping_price = params[:sku][:domestic_shipping_price].to_f * 100 if params[:sku][:domestic_shipping_price]
		@sku.international_shipping_price = params[:sku][:international_shipping_price].to_f * 100 if params[:sku][:international_shipping_price]
		
		if @current_author.skus << @sku
			process_attachments_for @sku
			
			
			if @sku.sku_type == 'merch'
				merch = Merch.new :owner => @current_author, :title => @sku.title, 
									:description => @sku.description, :book_id => @sku.book_id
				merch.attributes = params[:merches]
				
				merch.save
			
				@sku.add_item( merch )
			else
				if @sku.sku_type == 'ebook'
					asset = @sku.book.etexts.new :title => @sku.title
				else # it's an audiobook
					asset = @sku.book.audios.new :title => @sku.title, :duration => params[:duration], 
													:bitrate => params[:bitrate]
				end
				if asset.save
					process_attachments_for( asset )
				end
				
				@sku.add_item( asset )
			end
			
			pop_flash 'Sku saved!'
			redirect_to admin_author_store_index_path( @current_author )
		else
			pop_flash 'Sku could not be saved.', :error, @sku
			redirect_to :back
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
		redirect_to admin_author_store_index_path(@current_author)
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
		
		@items = @current_author.merches.published.map{ |m| [ "#{m.title} (#{m.class.name})", "#{m.class.name}_#{m.id}"] }
		@items += @current_author.published_assets.map{ |a| [ "#{a.title} (#{a.class.name})", "#{a.class.name}_#{a.id}"] }
		
		render :layout => '2col'
	end
	
	
	def new
		@sku = Sku.new
		@books = @current_author.books.published
		render :layout => '2col'
	end
	
	
	def sort
		@skus = @current_author.skus.published.order( 'listing_order asc' )
		render :layout => '2col'
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
		type, id = params[:item].split(/_/)
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
	
	def delete_sku
		@sku = Sku.find params[:id]
		if @sku.delete_sku
			pop_flash "Store Item deleted"
		else
			pop_flash "Could not remove store item", :error
		end
		redirect_to :back
	end


end
