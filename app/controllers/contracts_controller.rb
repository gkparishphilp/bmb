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
	
	def new
		@contract = Contract.new
	end
	
	def edit
		@contract = Contract.find( params[:id])
	end
	
	def create
		@contract = Contract.new( params[:contract])

		if @contract.save
			pop_flash 'Contract was successfully created.'
			redirect_to :back
		else
			pop_flash 'Oooops, contract not saved...', :error, @contract
			redirect_to :back
		end
	end
	
	def update
		# Don't ever want to delete old versions of the contract, so update creates a new on every time
		@contract = Contract.new( params[:contract] )
		
		if @contract.save
			pop_flash 'Contract was successfully created.'
			redirect_to :back
		else
			pop_flash 'Oooops, contract not saved...', :error, @contract
			redirect_to :back
		end
		
	end
end