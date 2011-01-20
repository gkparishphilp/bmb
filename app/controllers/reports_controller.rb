class ReportsController < ApplicationController

	def sales
		@start_date = params[:start_date] || 3.months.ago
		@end_date = params[:end_date] || Time.now 
		
		@orders = Order.for_author( @current_author )
		@orders_past_day = @orders.dated_between( Time.now, 1.day.ago )
		@orders_for_period = @orders.dated_between( @start_date, @end_date )
		@total_sales = @orders_for_period.select( "sum(orders.total) as total").all
		#@avg_daily_sales = @orders_for_period.select( "sum(orders.total) as total") / (@end_date - @start_date)

		
		@stub_data = [[ ['2010-1-1' , 34], ['2010-2-1', 21], ['2010-3-1', 24], ['2010-4-1', 24], ['2010-5-1', 8]  ]]
		@daily_sales = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, sum(orders.total) as total" ).map { |o| [o.created_at.to_s, o.total.to_f / 100] } ]
		@daily_orders = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, count(orders.id) as count" ).map { |o| [o.created_at.to_s, o.count] } ]
		@orders_by_sku = [ @orders_for_period.group( "orders.sku_id" ).select( "orders.sku_id, count(orders.id) as count").map {|o| [o.sku_id, o.count]} ]
		@orders_by_sku_xaxis =  @orders_for_period.group( "orders.sku_id" ).select( "orders.sku_id, count(orders.id) as count").map {|o| o.sku_id.to_s} 

		# Tried creating a data array formatted like [[["The Starter",10], ["The Rookie", 13], ...]] and having that print out as the x-axis on a bar chart, but that never worked
		# So creating a legend instead
		@legend = Hash.new
		
		for a in @orders_by_sku
			for b in a
				@legend[b[0]] = Sku.find( b[0].to_i).title
			end
		end
				
		render :layout  => 'reports'
	
	end

	def redemptions
		@start_date = params[:start_date] || 1.month.ago
		@end_date = params[:end_date] || Time.now
	
		@redemptions = Redemption.for_author( @current_author ).dated_between( @start_date, @end_date )

		@redemption_count = Array.new
		for coupon in @current_author.coupons
			@redemption_count << [coupon.id, coupon.code, coupon.sku.title, coupon.redemptions.redeemed.count]
		end	
	
	end


end