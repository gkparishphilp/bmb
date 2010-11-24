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

	def bought_merch(order, merch, user)
		@order = order
		@user = user
		@merch = merch
		mail( :from => "orders@backmybook.com", :to => "tay.x.nguyen@gmail.com", :subject => "Your purchase of #{merch.title}" )
	end
	
	def deliver_comment(comment)
		@comment = comment
		@commentable = @comment.commentable
		@users = @commentable.followers
		
		for @user in @users
			mail( :from => "donotreply@backmybook.com", :to => @user.email, :subject => "New comment to #{@commentable.title}")
		end
	end
end
