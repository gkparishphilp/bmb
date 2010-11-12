# == Schema Information
# Schema version: 20101110044151
#
# Table name: bundles
#
#  id                   :integer(4)      not null, primary key
#  owner_id             :integer(4)
#  owner_type           :string(255)
#  title                :string(255)
#  description          :text
#  price                :integer(4)
#  artwork_url          :string(255)
#  artwork_file_name    :string(255)
#  artwork_content_type :string(255)
#  artwork_file_size    :integer(4)
#  artwork_updated_at   :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

class Bundle < ActiveRecord::Base
	attr_accessor :assets
	has_many :coupons, :as => :redeemable
	has_many :orders, :as => :ordered
	has_many :bundle_assets
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to	:owner, :polymorphic => true
	has_many	:owners, :through => :ownings
	
end
