class UserMailer < ActionMailer::Base
	default :from => "from@example.com"

	def bought_merch(order, merch, user)
		@order = order
		@user = user
		@merch = merch
		mail(:from => "orders@backmybook.com", :to => "tay.x.nguyen@gmail.com", :subject => "Your purchase of #{merch.title}")
	end
end
