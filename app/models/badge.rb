# == Schema Information
# Schema version: 20101110044151
#
# Table name: badges
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)
#  display_name         :string(255)
#  badge_type           :string(255)
#  description          :string(255)
#  level                :integer(4)
#  artwork_file_name    :string(255)
#  artwork_content_type :string(255)
#  artwork_file_size    :integer(4)
#  artwork_updated_at   :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class Badge < ActiveRecord::Base
end
