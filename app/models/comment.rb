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