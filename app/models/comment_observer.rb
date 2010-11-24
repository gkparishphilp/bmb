class CommentObserver < ActiveRecord::Observer
	observe :comment
	def after_save(comment)
		UserMailer.deliver_comment(comment).deliver
	end
end