class LinksController < ApplicationController
	before_filter	:get_owner
	
	def admin
		@owner = @current_site
	end
	
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
			pop_flash 'Link was successfully created.', 'success'
			redirect_to admin_links_path
		else
			pop_flash 'Oooops, Link not saved...', 'error', @link
			render :action => :new
		end
	end

	def update
		@link = Link.find  params[:id] 
		
		check_link_permissions
		
		if @link.update_attributes(params[:link])
			pop_flash 'Link was successfully updated.', 'success'
			redirect_to  admin_site_links_path( @owner )
		else
			pop_flash 'Oooops, Link not updated...', 'error', @link
			render :action => :edit
		end
	end

	def destroy
		@link = Link.find  params[:id]
		@link.destroy
		pop_flash 'Link was successfully deleted.', 'success'
		go_to_link_owner
	end
	
private
	
	def get_owner
		@owner = Site.find params[:site_id] if params[:site_id]
	end
	
	def check_link_permissions
		if @link.owner_type == 'Site'
			unless @current_user.admin?
				pop_flash "Must be Admin", 'error'
				redirect_to root_path
				return false
			end
		end
	end
	
end
