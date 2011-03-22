# == Schema Information
# Schema version: 20110318174450
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
	# joins skus and sku-able entities
#	validates	:sku_id, :uniqueness => { :scope => [ :item_id, ;item_type ] }  #todo WTF, why won't this work????
	
	belongs_to	:sku
	belongs_to	:item, :polymorphic => true
	belongs_to	:asset, :class_name => 'Asset', :foreign_key => 'item_id'
	belongs_to	:merch, :class_name => 'Merch', :foreign_key => 'item_id'
	
	liquid_methods :title, :sku, :merch, :item
	
	def check_inventory_level
		if self.item_type == 'Merch' and self.merch.inventory_count == self.merch.inventory_warning
			
			# build message
			message_header = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">" + "<head> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /> <title>Inventory Warning</title> <body>"
			message_footer = "</body></html>"
			content = Liquid::Template.parse( self.sku.owner.email_templates.inventory_warning.last.content ).render('item' => self )
			message = message_header + content + message_footer
		
			#send message	
			ses = AWS::SES::Base.new(:access_key_id => AWS_ID, :secret_access_key => AWS_SECRET)
			ses.send_email( :to => self.sku.owner.user.email, :source =>'BackMyBook Support <support@backmybook.com>', :subject => "Inventory Level Warning", :html_body => message)
		end
	end
	
end
