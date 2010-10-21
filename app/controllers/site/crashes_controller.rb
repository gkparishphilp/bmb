class CrashesController < ApplicationController
	before_filter   :require_admin
	
	def index
		@crashes = Crash.all.reverse.paginate :page => params[:page], :per_page => 50
	end

	def show
		@crash = Crash.find params[:id]
	end
end