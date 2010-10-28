# == Schema Information
# Schema version: 20101026212141
#
# Table name: comments
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  commentable_id      :integer(4)
#  commentable_type    :string(255)
#  reply_to_comment_id :integer(4)
#  name                :string(255)
#  email               :string(255)
#  website_name        :string(255)
#  website_url         :string(255)
#  ip                  :string(255)
#  content             :text
#  created_at          :datetime
#  updated_at          :datetime
#

class Comment < ActiveRecord::Base
    
	before_save :strip_website_url
    
	belongs_to  :commentable, :polymorphic => :true
	belongs_to  :user
    
	validates_format_of :email, :if => :anonymous?,
						:with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
						:message => "Improperly formatted email address"
                                                       
	validates_presence_of :name, :if => :anonymous?
    
	validates_presence_of :content, :message => "You really should have to have something to say to post a comment :)"
        
protected
	def strip_website_url
		website_url.gsub!('http://', '') unless website_url.nil?
	end
                        
private
	def anonymous?
		self.user.anonymous?
	end
    
end
