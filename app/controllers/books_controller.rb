class BooksController < ApplicationController
	def new
		@author = Author.find params[:author_id]
		@book = Book.new
	end
	
	def create
		@book = Book.new params[:book]
		if @book.save
			pop_flash 'Book saved!', 'success'
		else
			pop_flash 'Book could not be saved.', 'error', @book
		end
		
		redirect_to admin_authors_path
	end
end
