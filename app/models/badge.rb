# == Schema Information
# Schema version: 20110602204757
#
# Table name: badges
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  display_name :string(255)
#  badge_type   :string(255)
#  description  :string(255)
#  level        :integer(4)
#  status       :string(255)     default("publish")
#  created_at   :datetime
#  updated_at   :datetime
#

class Badge < ActiveRecord::Base
end
