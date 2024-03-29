class ReportsController < ApplicationController
	require 'csv'
	before_filter	:get_admin
	before_filter	:check_permissions, :only => [:sales, :redemptions]
	
	def sales
		#todo - wow, this has grown pretty heinous.  Move into a model and clean up 
		#todo - catch error condition when start date is later than end date
		@start_date = params[:start_date] || 1.months.ago.getutc
		@end_date = params[:end_date] || Time.now.getutc 
		@week_ending = params[:week_ending] || Time.now.beginning_of_week
		
		@orders = Order.for_author( @current_author )
		# Active relation just passes in the day, starting at midnight.  So forwarding the end date by 1 day to capture today's purchases
		@orders_past_day = @orders.dated_between( 1.day.ago.getutc, Time.now.getutc + 1.day ).successful.order('created_at desc')
		@orders_for_period = @orders.dated_between( @start_date.to_date.beginning_of_day.getutc, @end_date.to_date.end_of_day.getutc).successful
		@orders_for_week_ending = @orders.dated_between( (@week_ending - 7.days).getutc, @week_ending.getutc).successful
		@total_sales = @orders_for_period.select( "sum(orders.total) as total").first.total.to_f
		@total_sales_tax = @orders_for_period.select( "sum(orders.tax_amount) as total").first.total.to_f
		@total_sales_shipping = @orders_for_period.select( "sum(orders.shipping_amount) as total").first.total.to_f
		@total_sales ||= 0
		@total_sales = @total_sales / 100 
		@total_sales_tax ||= 0
		@total_sales_tax = @total_sales_tax / 100
		@total_sales_shipping ||= 0
		@total_sales_shipping = @total_sales_shipping / 100
		@avg_daily_sales = @orders_for_period.select( "sum(orders.total) as total").first.total.to_f 
		@avg_daily_sales ||= 0
		@avg_daily_sales = @avg_daily_sales / (@end_date.to_date - @start_date.to_date) / 100

		# todo - Is there a way to do this with a triple join between orders, refunds, and sku's to make it @refund_total = Refund.for_author(@current_author).dated_between(...)
		@refunded_orders = @orders_for_period.refunded
		@refund_total= 0.0
		@refund_tax_total = 0.0
		@refund_shipping_total = 0.0
		@refund_item_total = 0.0
		
		for order in @refunded_orders
			if order.refund	# This is because some orders were marked as refunded after being refunded in the Paypal UI.  This was before you could do refunds entirely through BmB
				@refund_total += ( order.refund.total.to_f / 100 ) 
				@refund_tax_total += ( order.refund.tax_amount.to_f / 100 ) 
				@refund_shipping_total += ( order.refund.shipping_amount.to_f / 100 ) 
				@refund_item_total += ( order.refund.item_amount.to_f / 100 ) 
			end
		end
		
		@daily_sales = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, sum(orders.total) as total" ).map { |o| [o.created_at.to_s, o.total.to_f / 100] } ]
		@daily_orders = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, sum(orders.sku_quantity) as count" ).map { |o| [o.created_at.to_s, o.count] } ]
		@orders_by_sku_week_ending = [ @orders_for_week_ending.group( "orders.sku_id" ).select( "orders.sku_id, sum(orders.sku_quantity) as count").map {|o| [o.sku_id, o.count]} ]
		@orders_by_sku = [ @orders_for_period.group( "orders.sku_id" ).select( "orders.sku_id, sum(orders.sku_quantity) as count").map {|o| [o.sku_id, o.count]} ]
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
		@sends = @emails.delivered.count
		@opens = @emails.opened.count
	end
	
	def inventory
		@merches = @current_author.merches
		render :layout  => '2col'
		
	end
	
	def shipping
		@start_date = params[:start_date] || 1.months.ago.getutc
		@end_date = params[:end_date] || Time.now.getutc 
		
		unless Sku.for_author( @current_author ).has_merch.empty?

			@author_skus = Sku.for_author( @current_author ).has_merch.collect { |sku| [sku.title, sku.id] }

			if params[:sku]
				@sku = Sku.find( params[:sku][:id] )
			else
				@sku = Sku.find (@author_skus.first[1]) 
			end
		
			@orders_for_sku = Order.for_author( @current_author ).for_sku( @sku.id ).not_refunded
			@orders_for_period = @orders_for_sku.dated_between( @start_date.to_date.beginning_of_day.getutc, @end_date.to_date.end_of_day.getutc).successful.order( "created_at desc")

			if params[:download_csv]
				csv_string = CSV.generate do |csv|
					#header row
					csv << ["Date","Time","Customer Name", "Email","Quantity", "Street", "Street2", "City", "State/Province", "Zip/Postal Code","Country", "Personalization", "Order ID", "Order Reference #"]
					@orders_for_period.each do |order|
						order.billing_address.present? ? name = order.billing_address.name : name = order.shipping_address.name				
						csv << [order.created_at.strftime("%m/%d/%y"),order.created_at.strftime("%l:%M:%S %p"), name, order.email, order.sku_quantity, order.shipping_address.street, order.shipping_address.street2, order.shipping_address.city, order.shipping_address.state, order.shipping_address.zip, order.shipping_address.country, order.comment, order.id, order.order_transaction.reference]
				
					end
				end
	
				send_data csv_string,
					:type => 'text/csv; charset=iso-8859-1; header=present',
					:disposition => "attachment; filename = shipping_list.csv"
			end
			
		end

	end
	
	def royalty
		# Note that the start of the quarter is midnight GMT time, not midnight local time
		@start_date = Date.today.beginning_of_quarter
		@end_date = Time.now
		@orders = Order.for_author( @current_author ).dated_between( @start_date, @end_date ).successful.order( "created_at desc")
		
		@royalty = Report.calculate_current_quarter_royalty( @orders )
		
		render :layout => '2col'
	end
	
	private
	
	def get_admin
		if @current_author
			@admin = @current_author
		else
			require_admin
			@admin = @current_site
		end
	end
	
	def check_permissions
		unless @admin.has_valid_subscription?( Subscription.platform_builder)
			pop_flash "Update to the Author Platform Builder Account to access this feature!", :error
			redirect_to admin_index_path
		end
	end
	
end