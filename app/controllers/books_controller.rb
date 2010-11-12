class BooksController < ApplicationController
	before_filter :require_author, :except => [ :index, :show ]
	
	def new
		@book = Book.new
	end
	
	def confirm
		@title = params[:title]
		@amzn_response = Book.find_on_amazon @title
		
		if @amzn_response.empty?
			@book = @author.books.create :title => @title
			redirect_to edit_author_book_path( @author, @book )
		end
	end
	
	def edit
		@book = Book.find params[:id]
	end
	
	def update
		@book = Book.find params[:id] 

		if @book.update_attributes params[:book]
			if @book.avatar
				@book.avatar.update_from_resource( params[:attached_avatar_file] )
			else
				process_attachments_for( @book )
			end
			pop_flash 'Book was successfully updated.'
			redirect_to author_admin_index_path( @author )
		else
			pop_flash 'Oooops, Book not updated...', :error, @book
			render :action => :edit
		end
	end
	
	def create
		if params[:book][:asin].present?
			@book = Book.create_from_asin( params[:book][:asin], @author )
			redirect_to edit_author_book_path( @author, @book )
		else
			@book = Book.new params[:book]
			if @author.books << @book
				pop_flash 'Book saved!', 'success'
				redirect_to edit_author_book_path( @author, @book )
			else
				pop_flash 'Book could not be saved.', 'error', @book
				redirect_to new_author_book_path( @author )
			end
		
		end
	end
end
