# == Schema Information
# Schema version: 20101110044151
#
# Table name: backings
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  book_id     :integer(4)
#  points      :integer(4)      default(0)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Backing < ActiveRecord::Base
end
