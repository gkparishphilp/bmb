# == Schema Information
# Schema version: 20110826004210
#
# Table name: royalties
#
#  id         :integer(4)      not null, primary key
#  author_id  :integer(4)
#  order_id   :integer(4)
#  amount     :integer(4)
#  paid       :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class Royalty < ActiveRecord::Base
	belongs_to :author
end
