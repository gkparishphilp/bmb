class EmailTemplatesController < ApplicationController
	uses_tiny_mce

	def admin
		params[:email_template] ? @email_template = EmailTemplate.find(params[:email_template]) : @email_template = EmailTemplate.new
		render :layout => '2col'
	end

	def new
		@email_template = EmailTemplate.new
	end

	def edit
		@email_template = EmailTemplate.find params[:id]
	end

	def create
		@email_template = EmailTemplate.new params[:email_template]
		@email_template.owner = @current_author
		if @email_template.save
			redirect_to admin_email_templates_path
		else
			pop_flash 'Oooops, Email Message not saved...', 'error', @email_template
			render :action => :new
		end

	end
	
	def update
		@email_template = EmailTemplate.find params[:id] 

		if @email_template.update_attributes(params[:email_template])
			pop_flash 'Email Message was successfully updated.', 'success'
			redirect_to admin_email_templates_path
		else
			pop_flash 'Oooops, EmailMessage not updated...', 'error', @email_template
			render :action => :edit
		end
	end

	def destroy
		@email_template = EmailTemplate.find params[:id] 
		@email_template.destroy
		pop_flash 'Email template was successfully deleted', 'success'
		redirect_to admin_email_templates_path
	end

end