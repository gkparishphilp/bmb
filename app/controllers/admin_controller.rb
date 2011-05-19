class AdminController < ApplicationController
	# for author admin
	layout '3col'
	# make sure @current_user is an author or admin -- set @admin = @current_site or @admin
	before_filter :require_author 
	
	def books
		@books = @admin.books
	end
	
	def blog
		@articles = @admin.articles
	end
	
	def index
		@contract = Contract.last unless @current_author.agreed_to?( Contract.last )
		
		@orders = Order.for_author( @current_author )
		@week_ending = Time.now.beginning_of_week
		
		@orders_past_day = @orders.dated_between( 1.day.ago.getutc, Time.now.getutc + 1.day ).successful.order('created_at desc')
		@orders_for_week_ending = @orders.dated_between( (@week_ending - 7.days).getutc, @week_ending.getutc).successful
		@orders_by_sku_week_ending = [ @orders_for_week_ending.group( "orders.sku_id" ).select( "orders.sku_id, sum(orders.sku_quantity) as count").map {|o| [o.sku_id, o.count]} ]
	end
	
	def podcast
		@podcasts = @admin.podcasts
	end
	
	def events
		@event = params[:event_id] ? ( Event.find params[:event_id] ) : Event.new
		@events = @admin.events.upcomming
	end
	
	def forums
		@forum = params[:forum_id] ? ( Forum.find params[:forum_id] ) : Forum.new
		@forums = @admin.forums
	end
	
	def store
		@skus = @admin.skus
		@sku = Sku.new
	end
	
	def newsletter
		@campaign = EmailCampaign.find_by_owner_id_and_owner_type_and_title(@admin.id, 'Author', 'Default')
		params[:email_message] ? @email_message = EmailMessage.find(params[:email_message]) : @email_message = EmailMessage.new
	end
	
	def send_social_message
		@message = params[:message]
		for acct in params[:accts]
			acct_type, acct_id = acct.split(/_/)
			account = eval "#{acct_type.capitalize}Account.find acct_id"
			account.post_feed @message
		end
		pop_flash "Message Posted"
		redirect_to admin_social_media_path
	end
	
	def themes
		@default_themes = Theme.default - @admin.themes
	end

	def orders
		#Should resource orders properly to belong to authors and make this cleaner
		if params[:reference]
			if ot = OrderTransaction.find_by_reference( params[:reference] )
				@order = ot.order
				if @current_user.author != @order.sku.owner
					pop_flash "Not Your Order", :error
					redirect_to admin_orders_path
				end
			else
				pop_flash "Could not find order", :error
			end
		end
	end
	
	def free_download
		if params[:item]
			@asset = Asset.find params[:item][:item_id]
			@download_url = @asset.generate_secure_url
		end
	end

end

