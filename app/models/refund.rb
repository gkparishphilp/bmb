class Refund < ActiveRecord::Base
	belongs_to :order
	serialize :params
	validates :total, :presence => true
	validate_on_create :validate_amount, :validate_refundable
	
	def process
		
		self.item_amount ||= 0
		self.shipping_amount ||=0
		
		self.order.billing_address.state == self.order.sku.owner.user.billing_address.state ? self.tax_amount = (self.item_amount * self.order.sku.owner.taxrate).round : self.tax_amount = 0 
		
		self.total = self.item_amount + self.shipping_amount + self.tax_amount 
		
		response = GATEWAY.credit( self.total, self.order.order_transaction.reference )

		if response.success?
			self.params = response.params
			self.save
			return true
		else
			self.params = response.params
			self.save
			return false
		end
		
	end
	
	def validate_amount
		if self.total > order.total || self.total< 0
			message = "The total refund amount can't be greater than the order total." 
			errors.add_to_base message
		end
	end

	def validate_refundable
		if self.order.refund.present?
			message = "This order already has a refund associated with it.  If you'd like to create another refund, please contact customer support."
			errors.add_to_base message
		end
	end
end