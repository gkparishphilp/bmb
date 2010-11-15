class ThemesController < ApplicationController
	before_filter :get_author
	
	def create
		@theme = Theme.new params[:theme]
		@theme.author = @current_author
		if @theme.save
			process_attachments_for( @theme )
			pop_flash 'Theme saved!'
		else
			pop_flash 'Theme could not be saved.', :error, @theme
		end
		
		redirect_to admin_index_path

	end
	
	def update
		@theme = Theme.find params[:id]
		if @theme.update_attributes params[:theme]
			if @theme.bg
				@theme.bg.update_from_resource( params[:attached_bg_file] ) unless params[:attached_bg_file].blank? 
			else
				@theme.attachments.create_from_resource( params[:attached_bg_file], 'bg', :owner => @theme ) unless params[:attached_bg_file].blank? 
			end
			if @theme.banner
				@theme.banner.update_from_resource( params[:attached_banner_file] ) unless params[:attached_banner_file].blank?
			else
				@theme.attachments.create_from_resource( params[:attached_banner_file], 'banner', :owner => @theme ) unless params[:attached_banner_file].blank? 
			end
				
			pop_flash 'Theme saved!'
		else
			pop_flash 'Theme could not be saved.', :error, @theme
		end
		
		redirect_to admin_index_path

	end

private


end