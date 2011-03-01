class EmailMessagesController < ApplicationController
	before_filter :get_parent
	uses_tiny_mce 
	
	def admin
		params[:email_message] ? @email_message = EmailMessage.find(params[:email_message]) : @email_message = EmailMessage.new
		render :layout => '2col'
	end
	
	def admin_list
		@subscribings = @current_author.email_subscribings.reverse.paginate(:page => params[:page], :per_page => 10)
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
		html_body = @message.build_html_email(:test => true)

		if Delayed::Job.enqueue( SendEmailJob.new(@current_author.user, "#{@current_author.pen_name} <donotreply@backmybook.com>", "#{@message.subject} (Test Message)", html_body) )
			pop_flash( 'Test email sent' )
		else
			pop_flash( 'Error sending email' , :error )
		end
		redirect_to admin_email_messages_path
	end
	
	def send_to_subscriber
		@message = EmailMessage.find( params[:email_message] )
		@subscriptions = @current_author.email_subscribings.subscribed
		count = 0
		# Check and see how much quota we've got left and break it up according to quota
		# todo - this needs to be refactored for when multiple authors are sending newsletters
		# Need to look at the delayed_job queues and see how many email slots are open for that day
		
		quota_remaining = EmailDelivery.quota_remaining

		for @subscription in @subscriptions
			
			# Create an email_delivery entry so we have a unique tracking code to track status of this email over time
			@delivery_record = @subscription.email_deliveries.create
			@delivery_record.update_delivery_record_for( @message, 'created' )
			
			# Create HTML email message to be sent through AWS SES
			html_body = @message.build_html_email(:unsubscribe_code => @subscription.unsubscribe_code, :delivery_code => @delivery_record.code)
			
			#Calulate n days away we can schedule the send based on quota availability
			n = count.divmod( quota_remaining).first.to_i
			
			# Kick it to delayed_job to manage the send time and send load
			if Delayed::Job.enqueue( SendEmailJob.new(@subscription.subscriber, "#{@current_author.pen_name} <donotreply@backmybook.com>", "#{@message.subject}", html_body), 0 , n.days.from_now.getutc )
				@delivery_record.update_attributes :status => 'sent'
			else 
				pop_flash( "Error sending email to #{@subscription.subscriber.email} ", :error )
			end
	
			count += 1
			
		end
		pop_flash( "Your newsletter has been successfully queued for delivery!")
		@message.update_attributes :status => "Sent #{Time.now.to_date}"
		redirect_to admin_email_messages_path
		
	end
	
	private 
	
	def get_parent
		@campaign = @current_author.email_campaigns.find_by_title('Default')
	end
end
