class CrashesController < ApplicationController
	before_filter   :require_admin
	
	def index
		@crashes = @current_site.crashes.reverse.paginate :page => params[:page], :per_page => 50
	end

	def show
		@crash = Crash.find params[:id]
	end
	
	def update
		@crash = Crash.find( params[:id] )
		@crash.update_attributes( params[:crash] )
		pop_flash "Thanks for your feedback"
		redirect_to root_path
	end
end