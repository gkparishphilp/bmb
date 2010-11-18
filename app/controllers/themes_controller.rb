class ThemesController < ApplicationController
	
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
			process_attachments_for( @theme )
			pop_flash 'Theme saved!'
		else
			pop_flash 'Theme could not be saved.', :error, @theme
		end
		
		redirect_to admin_index_path

	end

private


end