class ReportsController < ApplicationController

	def sales
		#todo - catch error condition when start date is later than end date
		@start_date = params[:start_date] || 1.months.ago.getutc
		@end_date = params[:end_date] || Time.now.getutc 
		@week_ending = params[:week_ending] || Time.now.beginning_of_week
		
		@orders = Order.for_author( @current_author )
		# Active relation just passes in the day, starting at midnight.  So forwarding the end date by 1 day to capture today's purchases
		@orders_past_day = @orders.dated_between( 1.day.ago.getutc, Time.now.getutc + 1.day ).successful.order('created_at desc')
		@orders_for_period = @orders.dated_between( @start_date.to_date.beginning_of_day.getutc, @end_date.to_date.end_of_day.getutc).successful
		@orders_for_week_ending = @orders.dated_between( (@week_ending - 7.days).getutc, @week_ending.getutc).successful
		@total_sales = @orders_for_period.select( "sum(orders.total) as total").first.total / 100
		@avg_daily_sales = @orders_for_period.select( "sum(orders.total) as total").first.total / (@end_date.to_date - @start_date.to_date) / 100

		@daily_sales = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, sum(orders.total) as total" ).map { |o| [o.created_at.to_s, o.total.to_f / 100] } ]
		@daily_orders = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, count(orders.id) as count" ).map { |o| [o.created_at.to_s, o.count] } ]
		@orders_by_sku_week_ending = [ @orders_for_week_ending.group( "orders.sku_id" ).select( "orders.sku_id, count(orders.id) as count").map {|o| [o.sku_id, o.count]} ]
		@orders_by_sku = [ @orders_for_period.group( "orders.sku_id" ).select( "orders.sku_id, count(orders.id) as count").map {|o| [o.sku_id, o.count]} ]
		@orders_by_sku_xaxis =  @orders_for_period.group( "orders.sku_id" ).select( "orders.sku_id, count(orders.id) as count").map {|o| o.sku_id.to_s} 


		# Creating a data array with the title in it, like [[["The Starter",10], ["The Rookie", 13], ...]] for pie chart
		for a in @orders_by_sku
			for b in a
				b[0] = '(' + b[1].to_s + ')' + ' ' + Sku.find( b[0].to_i).title[0,30]
			end
		end

		for a in @orders_by_sku_week_ending
			for b in a
				b[0] = Sku.find( b[0].to_i).title
			end
		end
		
		render :layout  => 'reports'
	
	end

	def redemptions
		@start_date = params[:start_date] || 1.month.ago.getutc
		@end_date = params[:end_date] || Time.now.getutc
		
		@redemption_count = Array.new
		for coupon in @current_author.coupons
			@redemption_count << [coupon.id, coupon.code, coupon.sku.title, coupon.redemptions.dated_between(@start_date, @end_date).redeemed.count]
		end	
	
		render :layout  => '2col'	
	end

	def emails
		@start_date = params[:start_date] || 1.month.ago.getutc
		@end_date = params[:end_date] || Time.now.getutc
		
		@emails = EmailMessage.for_author( @current_author )
		@bounces = @emails.bounced.count
		@sends = @emails.sent.count
		@opens = @emails.opened.count
	end
	
	def inventory
		@skus = @current_author.skus
		render :layout  => '2col'
		
	end

end