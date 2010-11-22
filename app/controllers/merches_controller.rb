class MerchesController < ApplicationController

	def show
		@merch = Merch.find(params[:id])
		@orderable = @merch
	end

	def edit
		@merch = Merch.find(params[:id])
	end


	def create
		@merch = Merch.new params[:merch]
		@merch.owner = @current_author
		if @merch.save
			process_attachments_for( @merch )
			pop_flash 'Merchandise saved!'
		else
			pop_flash 'Merchandise could not be saved.', :error, @merch
		end
		
		redirect_to admin_index_path
	
	end


	def update
		@merch = Merch.find params[:id]

		if @merch.update_attributes params[:merch] 
			redirect_to @merch, :notice => 'Merchandise was successfully updated.'
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
