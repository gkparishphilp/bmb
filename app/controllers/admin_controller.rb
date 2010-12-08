class AdminController < ApplicationController
	# for author admin
	layout '3col'
	# make sure @current_user is an author or admin -- set @admin = @current_site or @admin
	before_filter :require_author_or_admin 
	
	
	def books
		@books = @admin.books
	end
	
	def blog
		@articles = @admin.articles
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
		one_day = 24 * 60 * 60
		@connection = AWS::S3::Base.establish_connection!(:access_key_id => S3_ID, :secret_access_key => S3_SECRET)
		@download_url = AWS::S3::S3Object.url_for('TheStarter.epub', 'bmb_downloads', :expires_in => one_day )

	end

end

