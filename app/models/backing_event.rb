# == Schema Information
# Schema version: 20110327221930
#
# Table name: backing_events
#
#  id         :integer(4)      not null, primary key
#  backing_id :integer(4)
#  event_type :string(255)
#  url        :string(255)
#  ip         :string(255)
#  points     :integer(4)      default(0)
#  created_at :datetime
#  updated_at :datetime
#

class BackingEvent < ActiveRecord::Base
	after_save	:add_points_to_backing
	
	belongs_to	:backing
	has_many	:raw_backing_events
	
	protected
	def add_points_to_backing
		self.backing.points += self.points if self.points_changed?
		self.backing.save
	end
end
