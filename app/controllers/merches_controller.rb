class MerchesController < ApplicationController	
	before_filter	:get_owner
	
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
			if @merch.price.to_i > 0
				sku = @current_author.skus.create :title => @merch.title, :description => @merch.description, :price => @merch.price, :book_id => @merch.book_id, :sku_type => 'merch'
				sku.add_item @merch
			end
			
			pop_flash 'Merchandise saved!'
			
			redirect_to admin_author_merches_path( @current_author, :book_id => @book )
			
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
	
	def get_owner
		@book = Book.find( params[:book_id] ) if params[:book_id]
	end
	
	def sort_column
		Merch.column_names.include?( params[:sort] ) ? params[:sort] : 'title'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end


end
