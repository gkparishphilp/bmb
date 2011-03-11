class EmailMessagesController < ApplicationController
	uses_tiny_mce 
	
	def admin
		@campaign = @current_author.email_campaigns.find_by_title('Default')
		@num_subscribers = @current_author.email_subscribings.count
		
		params[:email_message] ? @email_message = EmailMessage.find(params[:email_message]) : @email_message = EmailMessage.new
		render :layout => '2col'
	end
	
	def admin_list
		@num_subscribers = @current_author.email_subscribings.count
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
		@current_author.present? ? @email_message.sender = @current_author : @email_message.sender = @current_user

		if @email_message.email_type == 'newsletter'
			@email_message.source = @current_author.email_campaigns.find_by_title('Default')
			@email_message.save
			pop_flash 'Email message saved!'
			redirect_to admin_email_messages_path
			
		else @email_message.email_type == 'shipping'
			
			@email_message.save
			pop_flash 'Email message saved!'
			redirect_to admin_get_merch_orders_email_messages_path
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
	
	############################################
	# Methods for sending out email newsletters
	############################################
	
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
	
	#######################################################
	# Methods for sending out shipping confirmation emails
	#######################################################
	
	def admin_get_merch_orders
		@orders = Order.for_author( @current_author ).successful.has_shipping_amount.reverse.paginate( :page => params[:page], :per_page => 10 )
				render :layout  => '2col'
	end

	def admin_edit_shipping_email
		@order = Order.find params[:order_id]
		@email_message = retrieve_shipping_email(@order)
		render :layout  => '2col'
	end
	
	def admin_send_shipping_email
		@order = Order.find params[:order_id]

		@email_message = retrieve_shipping_email(@order)
		@email_message.save

		@testuser = User.find_by_email 'tay.x.nguyen@gmail.com'
		@user = @order.user
		
		if 	Delayed::Job.enqueue( SendEmailJob.new(@user, "#{@current_author.pen_name} <donotreply@backmybook.com>", @email_message.subject, @email_message.content) )
			@email_message.email_deliveries.create :status => 'sent'
			pop_flash 'Email sent!'
		else
			pop_flash 'Error sending email!', :error
		end
		redirect_to :back
	end
	

	
	private 
	
	def retrieve_shipping_email(order)
		# If delivery confirmation email exists, grab it, else create a new one from the template
		if order.email_messages.shipping.last.present?
			email_message = order.email_messages.shipping.last
		else
			subject = @current_author.email_templates.shipping.last.subject 
			content = Liquid::Template.parse( @current_author.email_templates.shipping.last.content ).render('order' => order, 'time' => Date.today.to_s(:long) ) 
			email_message = EmailMessage.new	:subject => subject, :content => content, :email_type => 'shipping', :sender => @current_author, :user_id => order.user.id, :source_id => order.id, :source_type => 'Order'
		end
		return email_message
	end
	
	def get_parent
		@campaign = @current_author.email_campaigns.find_by_title('Default')
	end
end
