# == Schema Information
# Schema version: 20101103181324
#
# Table name: reviews
#
#  id              :integer(4)      not null, primary key
#  reviewable_id   :integer(4)
#  reviewable_type :string(255)
#  user_id         :integer(4)
#  score           :integer(4)
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#

class Review < ActiveRecord::Base
	
	validates_uniqueness_of	:reviewable_id, :scope => [ :user_id, :reviewable_type ]
	
	belongs_to      :reviewable, :polymorphic => :true
	belongs_to      :user

end