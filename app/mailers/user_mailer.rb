class UserMailer < ActionMailer::Base

	def welcome( user, site )
		# setup instance variables for the view
		@user = user
		@current_site = site
		mail :to => "#{user.name}<#{user.email}>", :from => site.name, :subject => "Welcome to #{site.name}"
	end
	
	def forgot_password( user, site )
		# setup instance variables for the view
		@user = user
		@current_site = site		
		mail :to => "#{user.name}<#{user.email}>", :from => site.name, :subject => "Forgotten Password"
	end

	def bought_sku( order, user )
		@order = order
		@user = user
		@tax = @order.calculate_taxes if @order.sku.contains_merch?
		@shipping = @order.calculate_shipping if @order.sku.contains_merch?
		mail( :from => "orders@backmybook.com", :to => @user.email, :subject => "Your purchase of #{@order.sku.title}" )
	end
	
	def fulfill_order( order, user, paypal_details )
		@order = order
		@user = user
		@paypal_details = paypal_details
		mail( :from => "orders@backmybook.com", :to => @order.sku.owner.user.email, :subject => "You have an order to fulfill!")
	end
	
	def deliver_comment( comment )
		@comment = comment
		@commentable = @comment.commentable
		@users = @commentable.followers
		
		for @user in @users
			mail( :from => "donotreply@backmybook.com", :to => @user.email, :subject => "New comment to #{@commentable.title}")
		end
	end
	
	def support_email( contact )
		@contact = contact
		mail( :from => "donotreply@backmybook.com", :to => 'support@backmybook.com', :subject => "Support email from #{@contact.email}" )
	end
end
