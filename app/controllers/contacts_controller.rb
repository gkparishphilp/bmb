class ContactsController < ApplicationController
	before_filter   :require_admin, :except=>[ :new, :create, :inquiry ]
	
	def admin
		@contacts = @current_site.contacts.all
	end
	
	def index
		@contacts = @current_site.contacts.all
	end

	def show
		@contact = Contact.find params[:id]
	end

	def new
		@contact = Contact.new
		@subject = params[:subject] if params[:subject]
	end
	
	def inquiry
		@contact = Contact.new
	end

	def edit
		@contact = Contact.find params[:id]
	end

	def create
		@contact = Contact.new params[:contact]
		@contact.ip = request.ip
		
		if @current_user.anonymous?
			user = User.find_by_email params[:email]
			@contact.user = user
			if user.nil?
				user = User.new :email => params[:email], :site_id => @current_site.id
				if user.save
					@contact.user = user
				else 
					pop_flash "There was a problem with your message", :error, user
					redirect_to :back
					return false
				end
			end
		else 
			@contact.user = @current_user
		end
		
		#need to bypass recaptcha is current_user is logged in or human....
		if @current_user.anonymous? && !@current_user.human?
			if verify_recaptcha( :model => @contact ) && ( @current_site.contacts << @contact )
				pop_flash "Thanks for your message!"
				cookies[:human] = { :value => 'true', :expires => 10.minutes.from_now }
			else
				pop_flash "There was a problem with your message: ", :error, @contact
				redirect_to :back
				return false
			end
		elsif ( @current_site.contacts << @contact )
			pop_flash "Thanks for your message!"
		else
			pop_flash "There was a problem with your message: ", :error, @contact
			redirect_to :back
			return false
		end

		if @contact.author.present?
			# email the author
			send_email = UserMailer.author_contact_email( @contact ).deliver
			redirect_to @contact.author
		else
			#email BmB support
			send_email = UserMailer.support_email( @contact ).deliver
			redirect_to root_path
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
		@contact = Contact.find params[:id]
		@contact.destroy
		
		pop_flash 'Contact was successfully deleted.'
		redirect_to contacts_url
	end

end
