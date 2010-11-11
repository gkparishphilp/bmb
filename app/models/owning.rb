# == Schema Information
# Schema version: 20101110044151
#
# Table name: ownings
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  owner_type :string(255)
#  owned_id   :integer(4)
#  owned_type :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Owning < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
	belongs_to :owned, :polymorphic => true
end
