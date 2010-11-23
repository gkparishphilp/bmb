# == Schema Information
# Schema version: 20101120000321
#
# Table name: sku_items
#
#  sku_id     :integer(4)
#  item_id    :integer(4)
#  item_type  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SkuItem < ActiveRecord::Base
#	validates	:sku_id, :uniqueness => { :scope => [ :item_id, ;item_type ] }  #todo WTF, why won't this work????
	
	belongs_to	:sku
	belongs_to	:item, :polymorphic => true
	belongs_to	:asset, :class_name => 'Asset', :foreign_key => 'item_id'
	belongs_to	:merch, :class_name => 'Merch', :foreign_key => 'item_id'
end
