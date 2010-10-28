# == Schema Information
# Schema version: 20101026212141
#
# Table name: openids
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  identifier :string(255)
#  name       :string(255)
#  provider   :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Openid < ActiveRecord::Base

	belongs_to  :user

end
