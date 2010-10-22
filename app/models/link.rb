class Link < ActiveRecord::Base
	
	before_validation :clean_url
	validates_format_of	:url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

	belongs_to	:owner, :polymorphic => :true
	
protected
	
	def clean_url
		self.url = "http://" + self.url unless self.url =~ /\Ahttp:\/\//
	end
	
end