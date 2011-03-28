class MerchesController < ApplicationController
	def new
		@merch = Merch.new
		@books = @current_author.books
		render :layout => '3col'
	end
	
	def edit
		@merch = Merch.find params[:id]
		unless @merch.owner == @current_author
			pop_flash "You don't own this!", :error
			redirect_to root_path
			return false
		end
		@books = @current_author.books
		render :layout => '3col'
	end
	
	def show
		@merch = Merch.find params[:id] 
		redirect_to author_store_path( @merch.owner, @merch.skus.first )
	end


	def create
		@merch = Merch.new params[:merch]
		@merch.owner = @current_author
		if @merch.save
			process_attachments_for( @merch )
			if @merch.price.to_i > 0
				sku = @current_author.skus.create :title => @merch.title, :description => @merch.description, :price => @merch.price, :book_id => @merch.book_id, :sku_type => 'merch'
				sku.add_item @merch
			end
			
			pop_flash 'Merchandise saved!'
		else
			pop_flash 'Merchandise could not be saved.', :error, @merch
		end
		
		redirect_to admin_index_path
	
	end


	def update
		@merch = Merch.find params[:id]
		unless @merch.owner == @current_author
			pop_flash "You don't own this!", :error
			return false
		end
		if @merch.update_attributes params[:merch] 
			pop_flash 'Merchandise was successfully updated.'
		else
			pop_flash "Oooops, couldn't update Mercandise", :error, @merch
		end
		redirect_to :back
	end


	def destroy
		@merch = Merch.find(params[:id])
		@merch.destroy
		redirect_to :back
	end


end
