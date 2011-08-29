# == Schema Information
# Schema version: 20110826004210
#
# Table name: ownings
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  sku_id     :integer(4)
#  status     :string(255)     default("active")
#  delivered  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class Owning < ActiveRecord::Base
	belongs_to :user
	belongs_to :sku
end
