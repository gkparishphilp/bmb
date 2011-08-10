# == Schema Information
# Schema version: 20110606205010
#
# Table name: comments
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  commentable_id      :integer(4)
#  commentable_type    :string(255)
#  reply_to_comment_id :integer(4)
#  ip                  :string(255)
#  content             :text
#  created_at          :datetime
#  updated_at          :datetime
#

class Comment < ActiveRecord::Base

	after_create :check_for_spam
	    
	belongs_to  :commentable, :polymorphic => :true
	belongs_to  :user

	validates_presence_of :content, :message => "You really should have to have something to say to post a comment :)"
	
	scope :published, where("status = 'publish'")
	
	acts_as_followed
	
	def check_for_spam
		SpamFilter.filter( self )
	end
                


end



