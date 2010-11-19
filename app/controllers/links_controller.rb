class LinksController < ApplicationController
	before_filter	:get_owner
	
	def new
		@link = Link.new
	end

	def edit
		@link = @owner.links.find  params[:id]
		check_link_permissions
	end

	def create
		@link = Link.new params[:link]

		if @owner.links << @link
			pop_flash 'Link was successfully created.'
			redirect_to :back
		else
			pop_flash 'Oooops, Link not saved...', :error, @link
			redirect_to :back
		end
	end

	def update
		@link = Link.find  params[:id] 
		
		check_link_permissions
		
		if @link.update_attributes params[:link]
			pop_flash 'Link was successfully updated.'
			redirect_to  :back
		else
			pop_flash 'Oooops, Link not updated...', :error, @link
			redirect_to :back
		end
	end

	def destroy
		@link = Link.find  params[:id]
		@link.destroy
		pop_flash 'Link was successfully deleted.'
		redirect_to :back
	end
	
private
	
	def get_owner
		if params[:author_id]
			@owner = Author.find params[:author_id] 
		elsif params[:book_id]
			@owner = Book.find params[:book_id]
		else
			@owner = @current_site
		end
			 
	end
	
	def check_link_permissions
		if @link.owner_type == 'Site'
			unless @current_user.admin? @current_site
				pop_flash "Must be Admin", 'error'
				redirect_to root_path
				return false
			end
		end
	end
	
end
