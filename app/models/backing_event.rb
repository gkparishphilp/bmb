# == Schema Information
# Schema version: 20101110044151
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
end
