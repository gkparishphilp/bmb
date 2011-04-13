class RefundsController < ApplicationController

	def index
		@refunds = Refund.all
	end

	def show
		@refund = Refund.find params[:id]
	end

	def create
		@refund = Refund.new params[:refund]

		if @refund.process
			pop_flash 'Refund was successfully created.'
		else
			pop_flash 'Oooops, Refund not saved...', :error, @refund
		end
		redirect_to :back
	end

	def update
		@refund = Refund.find  params[:id] 
		if @refund.update_attributes params[:refund]
			pop_flash 'Refund was successfully updated.'
		else
			pop_flash 'Oooops, Refund not updated...', :error, @refund
		end
		redirect_to :back
	end

	def destroy
		@refund = Refund.find params[:id]
		@refund.destroy
		pop_flash 'Refund was successfully deleted.'
		redirect_to :back
	end
	
private 

end
