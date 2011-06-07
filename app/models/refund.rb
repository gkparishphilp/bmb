# == Schema Information
# Schema version: 20110606205010
#
# Table name: refunds
#
#  id              :integer(4)      not null, primary key
#  order_id        :integer(4)
#  item_amount     :integer(4)      default(0)
#  shipping_amount :integer(4)      default(0)
#  tax_amount      :integer(4)      default(0)
#  total           :integer(4)      default(0)
#  params          :string(255)
#  comment         :string(255)
#  status          :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class Refund < ActiveRecord::Base
	belongs_to :order
	serialize :params
	validates :total, :presence => true
	validate_on_create :validate_amount, :validate_refundable
	liquid_methods :item_amount, :shipping_amount, :tax_amount, :total, :order, :comment
	
	def process
		response = GATEWAY.credit( self.total, self.order.order_transaction.reference )

		self.params = response.params
		status = self.params.fetch("ack")
		status.match(/success/i) ? self.status = true : self.status = false	
		self.save
		
		return self.status
		
	end
	
	def validate_amount
		if self.total > order.total || self.total< 0
			message = "The total refund amount, #{self.total}, can't be greater than the order total." 
			errors.add_to_base message
		end
	end

	def validate_refundable
		if self.order.refund.present?
			message = "This order already has a refund associated with it.  If you'd like to create another refund, please contact customer support."
			errors.add_to_base message
		end
	end
	
	def send_email
		# build message
		content = Liquid::Template.parse( self.order.sku.owner.email_templates.refund.last.content ).render('refund' => self, :filters => [LiquidFilters] )
		
		#send message	
		EmailDelivery.ses_send('BackMyBook Support <support@backmybook.com>', self.order.email, "Refund for #{self.order.sku.title}", content)
	end
	
	def calculate_refund_amount
		
		if self.order.sku.contains_merch? && self.order.billing_address.state == self.order.sku.owner.user.billing_address.state 
			self.tax_amount = (self.item_amount * self.order.sku.owner.taxrate).round 
		else
			 self.tax_amount = 0 
		end
		
		self.total = self.item_amount + self.shipping_amount + self.tax_amount
	end
end
