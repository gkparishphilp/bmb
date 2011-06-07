class ForumsController < ApplicationController
	before_filter	:get_owner, :get_admin, :get_sidebar_data
	before_filter	:check_permissions, :only => [:admin, :new, :edit]

	layout			:set_layout
	
	def admin
		@forums = @owner.forums.all
		render :layout => '2col'
	end
	
	def index
		@forums = @owner.forums.paginate :page => params[:page], :order => 'id ASC', :per_page => 10
	end

	def show
		@forum = Forum.find params[:id] 
		set_meta @forum.title, @forum.description
	end

	def new
		@forum = Forum.new
		render :layout => '2col'
	end

	def edit
		@forum = Forum.find params[:id] 
		unless author_owns( @forum )
			redirect_to root_path
			return false
		end
		render :layout => '2col'
	end

	def create
		@forum = Forum.new params[:forum]
		
		if @owner.forums << @forum
			pop_flash 'Forum was successfully created.'
			redirect_to admin_author_forums_path( @current_author )
		else
			pop_flash 'Oooops, Forum not saved... ', :error, @forum
			render :action => "new" 
		end
	end

	def update
		@forum = Forum.find params[:id] 
		unless author_owns( @forum )
			redirect_to root_path
			return false
		end
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
	
private

	def get_owner
		@owner = @current_author ? @current_author : @author 
	end

	def get_admin
		@admin = @current_author ? @current_author : @current_site
		require_contributor if @admin == @current_site
	end

	def get_sidebar_data
		@upcoming_events = @owner.events.upcoming.published
	end

	def set_layout
		@author ? "authors" : "application"
	end

	def sort_column
		Event.column_names.include?( params[:sort] ) ? params[:sort] : 'starts_at'
	end

	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end

	def check_permissions
		unless @admin.has_valid_subscription?( Subscription.platform_builder)
			pop_flash "Update to the Author Platform Builder Account to access this feature!", :error
			redirect_to admin_index_path
		end
	end
	

	
	
end
