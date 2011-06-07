class LinksController < ApplicationController
	
	before_filter	:get_admin
	before_filter	:check_permissions, :only => [:admin, :new, :edit]
	helper_method	:sort_column, :sort_dir
	
	layout '2col'

	def admin
		@links = @admin.links.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
	end

	
	def new
		@link = Link.new
	end

	def edit
		@link = Link.find( params[:id] )
		verify_author_permissions( @link )
	end

	def create
		@link = Link.new( params[:link] )

		if @admin.links << @link
			pop_flash 'Link was successfully created.'
			redirect_to admin_links_url
		else
			pop_flash 'Oooops, Link not saved...', :error, @link
			redirect_to :back
		end
	end

	def update 
		@link = Link.find( params[:id] )
		verify_author_permissions( @link )
		
		if @link.update_attributes params[:link]
			pop_flash 'Link was successfully updated.'
			redirect_to  admin_links_url
		else
			pop_flash 'Oooops, Link not updated...', :error, @link
			redirect_to :back
		end
	end

	def destroy
		@link = Link.find( params[:id] )
		@link.destroy
		pop_flash 'Link was successfully deleted.'
		redirect_to admin_links_url
	end
	
private

	def get_admin
		@admin = @current_author ? @current_author : @current_site
		require_admin if @admin == @current_site
	end
	
	def sort_column
		Link.column_names.include?( params[:sort] ) ? params[:sort] : 'title'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'asc'
	end
	
	def check_permissions
		unless @admin.has_valid_subscription?( Subscription.platform_builder)
			pop_flash "Update to the Author Platform Builder Account to access this feature!", :error
			redirect_to admin_index_path
		end
	end
end
