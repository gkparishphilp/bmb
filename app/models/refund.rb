class Refund < ActiveRecord::Base
	belongs_to :order
	
	validates :total, :presence => true
	validate_on_create :validate_amount, :validate_refundable
	
	def process
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