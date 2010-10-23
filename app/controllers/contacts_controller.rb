class ContactsController < ApplicationController
	before_filter   :require_admin, :except=>[:new, :create]
	
	def admin
		@contacts = Contact.all
	end
	
	def index
		@contacts = Contact.all
	end

	def show
		@contact = Contact.find params[:id]
	end

	def new
		@contact = Contact.new
	end

	def edit
		@contact = Contact.find params[:id]
	end

	def create
		@contact = Contact.new params[:contact]
		@contact.ip = request.ip
		
		if @contact.save
			pop_flash 'Thank you for your message.'
			#email_args = {:subject => 'New contact email', :content => @contact.content}
			#send_email = MassMailer.deliver_admin_email(email_args)
			redirect_to root_path
		else
			pop_flash 'Oooops, Contact not saved...', :error, @contact
			render :action => :new
		end
	end

	def update
		@contact = Contact.find params[:id]

		if @contact.update_attributes params[:contact]
			pop_flash 'Contact was successfully updated.'
			redirect_to @contact
		else
			pop_flash 'Oooops, Contact not updated...', :error, @contact
			render :action => :edit
		end
	end

	def destroy
		@contact = Contact.find(params[:id])
		@contact.destroy
		
		pop_flash 'Contact was successfully deleted.'
		redirect_to contacts_url
	end

end
