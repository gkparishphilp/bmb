class BooksController < ApplicationController
	cache_sweeper :book_sweeper, :only => [:create, :update, :destroy]
	before_filter :require_author_or_admin, :except => [ :index, :show ]
	layout 'authors', :only => [ :index, :show, :mockup ]
	
	helper_method	:sort_column, :sort_dir
	
	def mockup
		@book = @author.books.first
		@reviewable = @book
	end
	
	def admin
		@books = @current_author.books.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		render :layout => '2col'
	end
	
	def digital_assets
		@book = Book.find params[:id]
		unless @book.author == @current_author
			pop_flash "You don't own this book", :error
			redirect_to root_path
			return false
		end
		render :layout => '2col'
	end
	
	def physical_assets
		@book = Book.find params[:id]
		unless @book.author == @current_author
			pop_flash "You don't own this book", :error
			redirect_to root_path
			return false
		end
		render :layout => '2col'
	end
	
	def index
		@books = @author.books.published
	end
	
	def show
		@book = Book.find params[:id]
		if @book.published?
			@reviewable = @book
			@review = Review.new
		
		
			set_meta "#{@book.title} by #{@book.author.pen_name}", @book.description

			#Increment view counter
			#@book.update_attributes :view_count => @book.view_count + 1
			@book.raw_stats.create :name =>'view', :ip => request.ip #Use raw_stats
			render :layout => 'authors'
		else
			pop_flash "Sorry, that item is not available.", :error
			redirect_to author_path( @author )
		end
	end
	
	def confirm
		@title = params[:title]
		@amzn_response = []
		@amzn_response = Book.find_on_amazon @title if params[:amazon]

		if @amzn_response.empty?
			@book = @author.books.create :title => @title
			redirect_to edit_author_book_path( @current_author, @book ), :layout => '2col'
		else
			render :layout => '2col'
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
		render :layout => '2col'
	end
	
	def new
		@book = Book.new
		render :layout => '2col'
	end
	
	def preview
		@book = Book.find( params[:id] )
		send_file @book.preview.location( nil, :full => true ), :disposition  => 'attachment', 
						:filename => @book.title + "_preview." + @book.preview.format
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
		redirect_to admin_author_books_path( @current_author )
	end
	
	def create
		if params[:book][:asin].present?
			@book = Book.create_from_asin( params[:book][:asin], @author )
			redirect_to edit_author_book_path( @author, @book )
		else
			@book = Book.new params[:book]
			if @author.books << @book
				process_attachments_for( @book )
				pop_flash 'Book saved!', 'success'
				redirect_to admin_author_books_path( @current_author )
			else
				pop_flash 'Book could not be saved.', 'error', @book
				redirect_to new_author_book_path( @current_author )
			end
		
		end
	end
	
	private
	
	def sort_column
		Book.column_names.include?( params[:sort] ) ? params[:sort] : 'title'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end
end
