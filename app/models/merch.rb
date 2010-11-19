# == Schema Information
# Schema version: 20101110044151
#
# Table name: merches
#
#  id              :integer(4)      not null, primary key
#  owner_id        :integer(4)
#  owner_type      :string(255)
#  title           :string(255)
#  description     :text
#  inventory_count :integer(4)      default(-1)
#  price           :integer(4)
#  status          :string(255)     default("publish")
#  created_at      :datetime
#  updated_at      :datetime
#

class Merch < ActiveRecord::Base
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to :owner, :polymorphic => true
	has_many :owners, :through => :ownings
	
	has_many :orders, :as => :ordered
	has_many :coupons, :as => :redeemable
	
	has_many	:sku_items, :as => :item
	has_many	:skus, :through => :sku_items

end
