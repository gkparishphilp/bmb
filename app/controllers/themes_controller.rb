class ThemesController < ApplicationController
	
	layout '3col', :except => :index
	
	def new
		@theme = Theme.new
	end
	
	def edit
		@theme = Theme.find params[:id]
	end
	
	def apply
		@theme = Theme.find params[:id]
		@theme.activate_for( @current_author )
		pop_flash "Theme Applied"
		redirect_to admin_themes_path
	end
	
	def index
		@themes = Theme.public#.paginate
		render :layout => 'application'
	end
	
	def create
		@theme = Theme.new params[:theme]
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