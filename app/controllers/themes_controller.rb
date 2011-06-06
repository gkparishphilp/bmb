class ThemesController < ApplicationController
	
	before_filter :require_author
	before_filter :check_permissions, :only => [:admin, :new, :edit]
	
	def admin
		@default_themes = Theme.default - @current_author.themes
		if true # todo @current_author.has_valid_subscription?( @marketing_subscription )
			render :layout => '2col'
		else
			pop_flash 'Please upgrade to access site customization options.', :error
			redirect_to :admin_index
		end
	end
	
	def new
		@edit_theme = Theme.new
		render :layout => '2col'
	end
	
	def edit
		@edit_theme = Theme.find params[:id]
		unless @edit_theme.creator == @current_author
			pop_flash "You don't own this theme!", :error
			redirect_to root_path
			return false
		end
		render :layout => '2col'
	end
	
	def activate
		author = Author.find params[:author_id]
		if params[:id] == 'none'
			@current_author.theme_ownings.find_by_theme_id( @current_author.active_theme.id ).deactivate
		else
			@theme = Theme.find params[:id]
			if @theme.nil? && @current_user.active_theme.present?
				owning_to_deactivate = @current_author.theme_ownings.find_by_theme_id( @current_author.active_theme.id )
				owning_to_deactivate.deactivate
				return true
			end
			@theme.activate_for( author )
		end
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
			@theme.activate_for( @current_author )
			pop_flash 'Theme saved!'
		else
			pop_flash 'Theme could not be saved.', :error, @theme
		end
		
		redirect_to admin_index_path

	end
	
	def update
		@theme = Theme.find params[:id]
		unless @theme.creator == @current_author
			pop_flash "You don't own this theme!", :error
			redirect_to root_path
			return false
		end
		if @theme.update_attributes params[:theme]
			process_attachments_for( @theme )
			pop_flash 'Theme saved!'
		else
			pop_flash 'Theme could not be saved.', :error, @theme
		end
		
		redirect_to admin_index_path

	end

private

	def check_permissions
		unless @admin.has_valid_subscription?( Subscription.platform_builder)
			pop_flash "Update to the Author Platform Builder Account to access this feature!", :error
			redirect_to admin_index_path
		end
	end

end