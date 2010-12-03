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
		mail( :from => "orders@backmybook.com", :to => @user.email, :subject => "Your purchase of #{@order.sku.title}" )
	end
	
	def fulfill_order( order, user )
		@order = order
		@user = user
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
		mail( :from => "donotreply@backmybook.com", :to => 'tay@backmybook.com', :subject => "Support email from #{@contact.email}" )
		mail( :from => "donotreply@backmybook.com", :to => 'wayland@backmybook.com', :subject => "Support email from #{@contact.email}" )
		mail( :from => "donotreply@backmybook.com", :to => 'gk@backmybook.com', :subject => "Support email from #{@contact.email}" )
		mail( :from => "donotreply@backmybook.com", :to => 'mike@backmybook.com', :subject => "Support email from #{@contact.email}" )
	end
end
