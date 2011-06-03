# == Schema Information
# Schema version: 20110602204757
#
# Table name: sku_items
#
#  id         :integer(4)      not null, primary key
#  sku_id     :integer(4)
#  item_id    :integer(4)
#  item_type  :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SkuItem < ActiveRecord::Base
	# joins skus and sku-able entities
#	validates	:sku_id, :uniqueness => { :scope => [ :item_id, ;item_type ] }  #todo WTF, why won't this work????
	
	belongs_to	:sku
	belongs_to	:item, :polymorphic => true
	belongs_to	:asset, :class_name => 'Asset', :foreign_key => 'item_id'
	belongs_to	:merch, :class_name => 'Merch', :foreign_key => 'item_id'
	
	liquid_methods :title, :sku, :merch, :item
	
	def check_inventory_warning
		if self.item_type == 'Merch' and self.merch.inventory_count == self.merch.inventory_warning
		
		#send email
		content = Liquid::Template.parse( self.sku.owner.email_templates.inventory_warning.last.content ).render('item' => self )
		EmailDelivery.ses_send('BackMyBook Support <support@backmybook.com>', self.sku.owner.user.email, 'Inventory Level Warning', content)
		end
	end
	
end
