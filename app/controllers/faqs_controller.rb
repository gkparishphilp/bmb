class FaqsController < ApplicationController
	# cache_sweeper :faq_sweeper, :only => [:create, :update, :destroy]
	before_filter :require_author_or_admin, :except => [ :index, :show ]
	layout 'authors', :only => [ :index, :show ]
	
	helper_method	:sort_column, :sort_dir
	
	def admin
		@faqs = @current_author.faqs.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		render :layout => '2col'
	end
	
	def index
		@faqs = @author.faqs.published
	end
	
	
	def edit
		@faq = Faq.find( params[:id] )
		unless @faq.author == @current_author
			pop_flash "You don't own this faq", :error
			redirect_to root_path
			return false
		end
		render :layout => '2col'
	end
	
	def new
		@faq = Faq.new
		render :layout => '2col'
	end
	
	
	def update
		@faq = Faq.find( params[:id] )
		unless @faq.author == @current_author
			pop_flash "You don't own this faq", :error
			return false
		end
		if @faq.update_attributes( params[:faq] )
			pop_flash 'FAQ was successfully updated.'
		else
			pop_flash 'Oooops, FAQ not updated...', :error, @faq
		end
		redirect_to admin_author_faqs_path( @current_author )
	end
	
	def create
		@faq = Faq.new( params[:faq] )
		if @current_author.faqs << @faq
			pop_flash 'FAQ saved!', 'success'
			redirect_to admin_author_faqs_path( @current_author )
		else
			pop_flash 'FAQ could not be saved.', 'error', @faq
			redirect_to new_author_faq_path( @current_author )
		end

	end
	
	private
	
	def sort_column
		Faq.column_names.include?( params[:sort] ) ? params[:sort] : 'liting_order'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end
end
