# == Schema Information
# Schema version: 20101026212141
#
# Table name: twitter_accounts
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  owner_type :string(255)
#  token      :string(255)
#  secret     :string(255)
#  twit_name  :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  twit_id    :integer(8)
#

class TwitterAccount < ActiveRecord::Base

	belongs_to  :owner, :polymorphic => :true

end
