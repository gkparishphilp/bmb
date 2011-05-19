class ContractsController < ApplicationController
	
	def agree
		contract = Contract.find( params[:id] )
		sig = params[:sig]
		agreement = ContractAgreement.new :author => @current_author, :sig => sig, :contract => contract
		agreement.save
		pop_flash "Thanks, your digital signature has been recorded."
		redirect_to :back
	end
	
	def show
		@contract = Contract.find( params[:id] )
	end
	
end