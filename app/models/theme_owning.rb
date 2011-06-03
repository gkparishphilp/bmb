# == Schema Information
# Schema version: 20110602204757
#
# Table name: theme_ownings
#
#  id         :integer(4)      not null, primary key
#  author_id  :integer(4)
#  theme_id   :integer(4)
#  active     :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class ThemeOwning < ActiveRecord::Base
	belongs_to	:author
	belongs_to	:theme
	
	def activate
		self.update_attributes :active => true
		return "activated #{self.id}"
	end
	
	def deactivate
		self.update_attributes :active => false
		return "deactivated #{self.id}"
	end
end
