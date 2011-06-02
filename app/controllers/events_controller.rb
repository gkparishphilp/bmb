class EventsController < ApplicationController
	before_filter	:get_owner, :get_admin, :get_sidebar_data
	
	layout			:set_layout
	
	helper_method	:sort_column, :sort_dir

	def admin
		@events = @admin.events.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		render :layout => '2col'
	end

	def index
		if ( @month = params[:month] ) && ( @year = params[:year] )
			@events = @owner.events.published.month_year( params[:month], params[:year] ).published.paginate :page => params[:page], :per_page => 10
		elsif @year = params[:year]
			@events = @owner.events.published.year( params[:year] ).published.paginate :page => params[:page], :per_page => 10
		else
			@events = @owner.events.upcoming.published.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
		end
	end
	
	def new
		@event = Event.new
		render :layout => '2col'
	end
	
	def edit
		@event = Event.find params[:id]
		verify_author_permissions( @event )
		render :layout => '2col'
	end


	def show
		@event = Event.find( params[:id] )
		set_meta @event.title, @event.description
	end
	
	def create
		@event = Event.new( params[:event] )

		if @admin.events << @event
			pop_flash 'Event was successfully created.'
			redirect_to admin_events_url
		else
			pop_flash 'Oooops, Event not saved...', :error, @event
			render :action => :new
		end
	end

	def update
		@event = Event.find  params[:id] 
		verify_author_permissions( @event )
		if @event.update_attributes( params[:event] )
			pop_flash 'Event was successfully updated.'
			redirect_to admin_events_url
		else
			pop_flash 'Oooops, Event not updated...', :error, @event
			render :action => :edit
		end
	end

	def destroy
		@event = Event.find params[:id]
		@event.destroy
		pop_flash 'Event was successfully deleted.'
		redirect_to admin_events_url
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
	
end
