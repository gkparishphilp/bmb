# == Schema Information
# Schema version: 20101110044151
#
# Table name: links
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  owner_type  :string(255)
#  title       :string(255)
#  url         :string(255)
#  description :string(255)
#  link_type   :string(255)
#  status      :string(255)     default("publish")
#  created_at  :datetime
#  updated_at  :datetime
#

class Link < ActiveRecord::Base
	
	before_validation :clean_url
	validates_format_of	:url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

	belongs_to	:owner, :polymorphic => :true
	
protected
	
	def clean_url
		self.url = "http://" + self.url unless self.url =~ /\Ahttp:\/\//
	end
	
end
