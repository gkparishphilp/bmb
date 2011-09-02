# == Schema Information
# Schema version: 20110826004210
#
# Table name: badgings
#
#  id             :integer(4)      not null, primary key
#  badge_id       :integer(4)
#  badgeable_id   :integer(4)
#  badgeable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Badging < ActiveRecord::Base
end
