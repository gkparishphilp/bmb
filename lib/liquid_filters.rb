module LiquidFilters
	include ActionView::Helpers::NumberHelper
	
	def currency( total )
		number_to_currency( total.to_f/100 )
	end
end

Liquid::Template.register_filter(LiquidFilters)
