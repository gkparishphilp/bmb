class AuthorAdminController < ApplicationController
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
		
		@stub_data = [[ ['2010-1-1' , 34], ['2010-2-1', 21], ['2010-3-1', 24], ['2010-4-1', 2344]  ]]
		@chart_data = [ @orders_for_period.group( "date(orders.created_at)" ).select( "orders.created_at, sum(orders.total) as total" ).map { |o| [o.created_at.to_s, o.total.to_f / 100] } ]
		
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

end

