class CommentObserver < ActiveModel::Observer
	def after_save(comment)
		UserMailer.deliver_comment(comment)
	end
end