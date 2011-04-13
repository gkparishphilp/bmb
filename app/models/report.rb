class Report < ActiveRecord::Base
	def self.calculate_current_quarter_royalty( orders)

		net_royalty_rate = 0.90
		payment_processing_rate = 0.04
		 
		item_total = 0
		shipping_total = 0
		tax_total = 0
		refund_item_total = 0
		refund_shipping_total = 0
		refund_tax_total = 0
		
		
		for order in orders
			item_total += order.total - order.tax_amount - order.shipping_amount
			shipping_total += order.shipping_amount
			tax_total += tax_total

			if order.refund
				refund_item_total -= order.refund.item_amount
				refund_shipping_total -= order.refund.shipping_amount 
				refund_tax_total -= order.refund.tax_amount 
			end
			
		end
		
		author_royalty =	(item_total - refund_item_total) * (net_royalty_rate - payment_processing_rate) + 
								(shipping_total - refund_shipping_total) * (1.0 - payment_processing_rate) +
								(tax_total - refund_tax_total) * (1.0 - payment_processing_rate)
		
		backmybook_royalty =	(item_total - refund_item_total) * (1.0 - net_royalty_rate + payment_processing_rate) +
								(shipping_total - refund_shipping_total) * (payment_processing_rate) +
									(tax_total - refund_tax_total) * (payment_processing_rate)

		total_revenue = (item_total - refund_item_total) + (shipping_total - refund_shipping_total) + 	(tax_total - refund_tax_total)

		royalty_info = {"author_royalty" => author_royalty, 
						"backmybook_royalty" => backmybook_royalty,
						"total" => total_revenue						
						}
		
	end
	
end