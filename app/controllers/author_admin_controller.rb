class AuthorAdminController < ApplicationController
	## todo THIS IS OLD - NEED TO CLEAN UP AS ADMIN CONSOLE IS BUILT
	
	# for author admin to expose functional pieces as they become baked
	
	
	layout '3col'
	# make sure @current_user is an author or admin -- set @admin = @current_site or @admin
	before_filter :require_author_or_admin 
	
	def blog
		@articles = @admin.articles
	end
	
	def events
		@event = params[:event_id] ? ( Event.find params[:event_id] ) : Event.new
		@events = @admin.events.upcomming
	end
	
	def forums
		@forum = params[:forum_id] ? ( Forum.find params[:forum_id] ) : Forum.new
		@forums = @admin.forums
	end
	
	def orders
		@start_date = params[:start_date] || 3.months.ago
		@end_date = params[:end_date] || Time.now 
		
		@orders = Order.for_author( @current_author )
		@orders_past_day = @orders.dated_between( Time.now, 1.day.ago )
		@orders_for_period = @orders.dated_between( @start_date, @end_date )
		@avg_daily_sales = @orders_for_period.select( "sum(orders.total) as total")

		
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
		@start_date = params[:start_date] || 7.days.ago
		@end_date = params[:end_date] || Time.now
		@redemptions = Redemption.for_author( @current_author ).dated_between( @start_date, @end_date )

		@redemption_count = Array.new
		for coupon in @current_author.coupons
			@redemption_count << [coupon.id, coupon.code, coupon.sku.title, coupon.redemptions.redeemed.count]
		end	
	end
	
	def order_detail
		@order = Order.find params[:id]
	end
	
	def newsletters
		@campaign = EmailCampaign.find_by_owner_id_and_owner_type_and_title(@current_author.id, 'Author', 'Default')
		params[:email_message] ? @email_message = EmailMessage.find(params[:email_message]) : @email_message = EmailMessage.new
	end
	
	def send_to_self
		@message = EmailMessage.find( params[:email_message] )
		MarketingMailer.send_to_self( @message, @current_author ).deliver ? pop_flash( 'Email sent' ) : pop_flash( 'Email Errored Out' , :error )
		redirect_to author_admin_newsletters_url
	end
	
	def send_to_all
		@message = EmailMessage.find( params[:email_message] )
		@subscriptions = @current_author.email_subscribings.subscribed
		for @subscription in @subscriptions
			MarketingMailer.send_to_all( @message, @current_author, @subscription).deliver ? pop_flash( 'Email sent' ) : pop_flash( 'Error sending email', :error )
		end
		redirect_to author_admin_newsletters_url
		
	end

end

