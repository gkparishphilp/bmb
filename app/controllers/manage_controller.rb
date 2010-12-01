class ManageController < ApplicationController
	# for managing the site
	layout '3col'
	# make sure @current_user is an admin -- set @admin = @current_site 
	before_filter :require_admin 
	
	
	def blog
		@articles = @admin.articles
	end
	
	def podcast
		@podcasts = @admin.podcasts
	end
	
	def events
		@events = @admin.events.upcomming
	end
	
	def forums
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

end

