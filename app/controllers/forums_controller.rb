class ForumsController < ApplicationController
	before_filter	:require_admin, :except => [ :index, :show ]
	
	def admin
		@forums = @current_site.forums.all
	end
	
	def index
		@forums = @current_site.forums.paginate :page => params[:page], :order => 'id ASC', :per_page => 10
	end

	def show
		@forum = Forum.find params[:id] 
		set_meta @forum.title, @forum.description
	end

	def new
		@forum = Forum.new
	end

	def edit
		@forum = Forum.find params[:id] 
	end

	def create
		@forum = Forum.new params[:forum]
		
		if @current_site.forums << @forum
			pop_flash 'Forum was successfully created.'
			redirect_to admin_forums_path 
		else
			pop_flash 'Oooops, Forum not saved... ', :error, @forum
			render :action => "new" 
		end
	end

	def update
		@forum = Forum.find params[:id] 

		if @forum.update_attributes params[:forum]
			pop_flash 'Forum was successfully updated.'
			redirect_to admin_forums_path
		else
			pop_flash 'Oooops, Forum not updated... ', :error, @forum
			render :action => "edit"
		end
	end

	def destroy
		@forum = Forum.find params[:id] 
		@forum.destroy

		redirect_to admin_forums_path
	end
	
	

	
end
