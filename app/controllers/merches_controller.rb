class MerchesController < ApplicationController

	def index
		@merches = Merch.all
	end


	def show
		@merch = Merch.find(params[:id])
		@orderable = @merch
	end


	def new
		@merch = Merch.new
	end

	def edit
		@merch = Merch.find(params[:id])
	end


	def create
		@merch = Merch.new params[:merch]
	
		if @merch.save
			redirect_to @merch, :notice => "Merch was successfully created."
		else
			render :action => "new" 	
		end
	
	end


	def update
		@merch = Merch.find params[:id]

		if @merch.update_attributes(params[:merch])
			redirect_to @merch, :notice => 'Merch was successfully updated.'
		else
			render :action => "edit" 
		end
	end


	def destroy
		@merch = Merch.find(params[:id])
		@merch.destroy
		redirect_to merches_url
	end


end
