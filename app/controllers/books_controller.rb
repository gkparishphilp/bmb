class BooksController < ApplicationController
	cache_sweeper :book_sweeper, :only => [:create, :update, :destroy]
	before_filter :require_author_or_admin, :except => [ :index, :show ]
	layout 'authors', :only => [ :index, :show, :mockup ]
	
	def mockup
		@book = @author.books.first
		@reviewable = @book
	end
	
	def index
		@books = @author.books #.published
	end
	
	def show
		@book = Book.find params[:id]
		@reviewable = @book
		@review = Review.new
		
		
		set_meta "#{@book.title} by #{@book.author.pen_name}", @book.description

		#Increment view counter
		#@book.update_attributes :view_count => @book.view_count + 1
		@book.raw_stats.create :name =>'view', :ip => request.ip #Use raw_stats
		render :layout => 'authors'
	end
	
	def confirm
		@title = params[:title]
		@amzn_response = []
		@amzn_response = Book.find_on_amazon @title if params[:amazon]

		if @amzn_response.empty?
			@book = @author.books.create :title => @title
			redirect_to edit_author_book_path( @current_author, @book ), :layout => '3col'
		else
			render :layout => '3col'
		end
	end
	
	def edit
		@book = Book.find params[:id]
		unless @book.author == @current_author
			pop_flash "You don't own this book", :error
			redirect_to root_path
			return false
		end
		@genres = [Genre.new( :id => nil, :name => "Please Select a Genre")]
		@genres += Genre.find_by_name( 'fiction' ).children
		@genres += Genre.find_by_name( 'non fiction' ).children
		render :layout => '3col'
	end
	
	def new
		render :layout => '3col'
	end
	
	def update
		@book = Book.find params[:id] 
		unless @book.author == @current_author
			pop_flash "You don't own this book", :error		#	redirect_to root_path
			return false
		end
		if @book.update_attributes params[:book]
			process_attachments_for( @book )
			pop_flash 'Book was successfully updated.'
		else
			pop_flash 'Oooops, Book not updated...', :error, @book
		end
		redirect_to :back
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
