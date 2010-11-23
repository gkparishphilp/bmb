class CommentObserver < ActiveRecord::Observer
	
	def after_save(comment)
		UserMailer.deliver_comment(comment)
	end
end