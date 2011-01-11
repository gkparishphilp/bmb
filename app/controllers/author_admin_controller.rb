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
	
	def reports
		@orders = @current_author.orders.sort!{ |a,b| b.created_at <=> a.created_at}
		@orders_past_day = @orders.select{ |c| c.created_at > 1.day.ago}
		@orders_past_week = @orders.select{ |d| d.created_at > 1.week.ago}
	end
	
	def order_detail
		@order = Order.find params[:id]
	end

end

