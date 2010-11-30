class EventsController < ApplicationController
	before_filter	:get_owner, :get_sidebar_data
	layout			:set_layout

	def index
		if ( @month = params[:month] ) && ( @year = params[:year] )
			@events = @owner.events.month_year( params[:month], params[:year] ).published.paginate :page => params[:page], :per_page => 10
		elsif @year = params[:year]
			@events = @owner.events.year( params[:year] ).published.paginate :page => params[:page], :per_page => 10
		else
			@events = @owner.events.published.paginate :page => params[:page], :order => 'created_at desc', :per_page => 10
		end
	end
	
	def new
		@event = Event.new
		render :layout => '3col'
	end
	
	def edit
		@event = Event.find params[:id]
		render :layout => '3col'
	end


	def show
		@event = Event.find params[:id]
		
		set_meta @event.title, @event.description
		
	end
	
	def create
		@event = Event.new params[:event]

		if @owner.events << @event
			pop_flash 'Event was successfully created.'
			redirect_to :back
		else
			pop_flash 'Oooops, Event not saved...', :error, @event
			render :action => :new
		end
	end

	def update
		@event = Event.find  params[:id] 

		if @event.update_attributes params[:event]
			pop_flash 'Event was successfully updated.'
			redirect_to :back
		else
			pop_flash 'Oooops, Event not updated...', :error, @event
			render :action => :edit
		end
	end

	def destroy
		@event = Event.find params[:id]
		@event.destroy
		pop_flash 'Event was successfully deleted.'
		redirect_to :back
	end
	
private
	
	def get_owner
		@owner = @author ? @author : @current_site
	end

	def get_sidebar_data
		@upcomming_events = @owner.events.upcomming.published
	end
	
	def set_layout
		@author ? "authors" : "application"
	end
	
end
