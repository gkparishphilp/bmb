# == Schema Information
# Schema version: 20110826004210
#
# Table name: affiliates
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Affiliate < ActiveRecord::Base
	belongs_to	:user
end
