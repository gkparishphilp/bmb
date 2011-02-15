class SkusController < ApplicationController
	cache_sweeper :sku_sweeper, :only => [:create, :update, :destroy]
	
	def create
		@sku = Sku.new params[:sku]
		@sku.sku_type = 'custom' #since the only way to hit this is through admin
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
		unless author_owns( @sku )
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
		unless author_owns( @sku )
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
