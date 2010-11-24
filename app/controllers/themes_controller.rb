class ThemesController < ApplicationController
	
	def new
		@edit_theme = Theme.new
		render :layout => '3col'
	end
	
	def edit
		@edit_theme = Theme.find params[:id]
		render :layout => '3col'
	end
	
	def activate
		author = Author.find params[:author_id]
		@theme = Theme.find params[:id]
		if @theme.nil? && @current_user.active_theme.present?
			owning_to_deactivate = @current_author.theme_ownings.find_by_theme_id( @current_author.active_theme.id )
			owning_to_deactivate.deactivate
			return true
		end
		@theme.activate_for( author )
		pop_flash "Theme Activated"
		redirect_to admin_themes_path
	end
	
	def index
		@themes = Theme.public#.paginate
		render :layout => 'application'
	end
	
	def create
		@theme = Theme.new params[:theme]
		@theme.creator = @current_author
		if @current_author.themes << @theme
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
			process_attachments_for( @theme )
			pop_flash 'Theme saved!'
		else
			pop_flash 'Theme could not be saved.', :error, @theme
		end
		
		redirect_to admin_index_path

	end

private


end