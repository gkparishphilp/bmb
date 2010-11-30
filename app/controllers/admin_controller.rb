class AdminController < ApplicationController
	# for author admin
	layout '3col'
	before_filter :require_author # make sure @current_user is an author and punt if not
	
	
	def books
		@books = @current_author.books
	end
	
	def blog
		@articles = @current_author.articles
	end
	
	def podcast
		@podcast = params[:podcast_id] ? ( Podcast.find params[:podcast_id] ) : Podcast.new
		@podcasts = @current_author.podcasts
	end
	
	def events
		@event = params[:event_id] ? ( Event.find params[:event_id] ) : Event.new
		@events = @current_author.events.upcomming
	end
	
	def forums
		@forum = params[:forum_id] ? ( Forum.find params[:forum_id] ) : Forum.new
		@forums = @current_author.forums
	end
	
	def store
		@skus = @current_author.skus
		@sku = Sku.new
	end
	
	def newsletter
		@campaign = EmailCampaign.find_by_owner_id_and_owner_type_and_title(@current_author.id, 'Author', 'Default')
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
		@default_themes = Theme.default
	end

end

