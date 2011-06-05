<<<<<<< HEAD:app/controllers/merches_controller.rb
class MerchesController < ApplicationController
	
	before_filter	:get_parents
=======
class MerchesController < ApplicationController	
	before_filter	:get_owner
>>>>>>> 6443a1d3a59c576b8537c717338af6a517af8589:app/controllers/merches_controller.rb
	
	helper_method	:sort_column, :sort_dir
	
	
	def admin
		if @book
			@merches = @book.merches.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		else
			@merches = @current_author.merches.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		end
		render :layout => '2col'
	end
	
	def new
		@merch = Merch.new
		@sku = Sku.find_by_id( params[:sku_id] )
		@books = @current_author.books

		if @book
			@merch_title = @book.title
		end
		render :layout => '2col'
	end
	
	def edit
		@merch = Merch.find params[:id]
		unless @merch.owner == @current_author
			pop_flash "You don't own this!", :error
			redirect_to root_path
			return false
		end
		@books = @current_author.books
		render :layout => '2col'
	end
	
	def show
		@merch = Merch.find params[:id] 
		if @merch.published?
			redirect_to author_store_path( @merch.owner, @merch.skus.first )
		else
			pop_flash "Sorry, that item is not available", :error
			redirect_to author_path( @merch.owner )
		end
	end


	def create
		@merch = Merch.new( params[:merch] )
		@merch.owner = @current_author
		@merch.book_id = @book.id if @book
		if @merch.save
			process_attachments_for( @merch )
			@sku.add_item( @merch )
			
			pop_flash 'Merchandise saved!'
			
			redirect_to edit_author_sku_path( @current_author, @sku )
			
		else
			pop_flash 'Merchandise could not be saved.', :error, @merch
			redirect_to :back
		end
		
		
	
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
	
	private
	
	def get_parents
		@book = Book.find_by_id( params[:book_id] )
		@sku = Sku.find_by_id( params[:sku_id] )
	end
	
	def sort_column
		Merch.column_names.include?( params[:sort] ) ? params[:sort] : 'title'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end


end
