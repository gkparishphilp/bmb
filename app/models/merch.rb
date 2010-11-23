# == Schema Information
# Schema version: 20101120000321
#
# Table name: merches
#
#  id              :integer(4)      not null, primary key
#  owner_id        :integer(4)
#  owner_type      :string(255)
#  book_id         :integer(4)
#  title           :string(255)
#  description     :text
#  inventory_count :integer(4)      default(-1)
#  status          :string(255)     default("publish")
#  created_at      :datetime
#  updated_at      :datetime
#

class Merch < ActiveRecord::Base
	validates	:title, :uniqueness => { :scope => [ :owner_id, :owner_type ] }
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to :owner, :polymorphic => true
	has_many :owners, :through => :ownings
	
	belongs_to	:book #sometimes.... not necessarily
	
	has_many :orders, :as => :ordered
	has_many :coupons, :as => :redeemable
	
	has_many	:sku_items, :as => :item
	has_many	:skus, :through => :sku_items
	
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :profile => "233", :thumb => "100", :tiny => "40"}}
	
	attr_accessor	:price
	

end
