class EmailMessagesController < ApplicationController
	before_filter :get_parent
	uses_tiny_mce 
	
	def admin
		params[:email_message] ? @email_message = EmailMessage.find(params[:email_message]) : @email_message = EmailMessage.new
		render :layout => '2col'
	end
	
	def admin_list
		render :layout => '3col'
	end
	
	def new
	end

	def edit
		@email_message = EmailMessage.find params[:id]
	end

	def create
		@email_message = EmailMessage.new params[:email_message]
		@email_message.email_campaign = @campaign
		
		if @email_message.save
			redirect_to admin_email_messages_path
		else
			pop_flash 'Oooops, Email Message not saved...', 'error', @email_message
			render :action => :new
		end

	end
	
	def update
		@email_message = EmailMessage.find params[:id] 

		if @email_message.update_attributes(params[:email_message])
			pop_flash 'Email Message was successfully updated.', 'success'
			redirect_to admin_email_messages_path
		else
			pop_flash 'Oooops, EmailMessage not updated...', 'error', @email_message
			render :action => :edit
		end
	end
	
	def destroy
		@email_message = EmailMessage.find params[:id] 
		@email_message.destroy
		pop_flash 'Email message was successfully deleted', 'success'
		redirect_to admin_email_messages_path
	end
	
	def send_to_self
		@message = EmailMessage.find( params[:email_message] )
		MarketingMailer.send_to_self( @message, @current_author ).deliver ? pop_flash( 'Email sent' ) : pop_flash( 'Email Errored Out' , :error )
		redirect_to admin_email_messages_path
	end
	
	def send_to_subscriber
		@message = EmailMessage.find( params[:email_message] )
		@subscriptions = @current_author.email_subscribings.subscribed
		for @subscription in @subscriptions
			
			# Create an email_delivery entry so we have a unique tracking code to track status of this email over time
			@delivery_record = @subscription.email_deliveries.create
			@delivery_record.update_delivery_record_for( @message, 'created' )
			
			if 	MarketingMailer.send_to_subscriber( @message, @current_author, @subscription, @delivery_record ).deliver 
				@delivery_record.update_attributes :status => 'sent'
			else 
				pop_flash( "Error sending email to #{@subscription.subscriber.email} ", :error )
			end
		end
		pop_flash( "Email newsletters sent")
		@message.update_attributes :status => "Sent #{Time.now.to_date}"
		redirect_to admin_email_messages_path
		
	end
	
	private 
	
	def get_parent
		@campaign = @current_author.email_campaigns.find_by_title('Default')
	end
end
