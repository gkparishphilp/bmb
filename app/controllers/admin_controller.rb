class AdminController < ApplicationController
	# for author admin
	layout '2col'

	before_filter :require_author, :except => [:site] 
	before_filter :require_admin, :only => [:site]
	
	
	
	def index
		if  @current_author.skus.present? 
			@contract = Contract.reseller unless @current_author.agreed_to?( Contract.reseller )
		end
		
		@orders = Order.for_author( @current_author )		
		@recent_orders = @orders.successful.order('created_at desc').limit( 10 )
	end
	

	def site_config
		@author = @current_author
		if @author.has_valid_subscription?( Subscription.first )
			render :layout => '2col'
		else
			pop_flash 'Please upgrade to access site customization options.', :error
			redirect_to :admin_index
		end
	end
	
	def faq
		@faq = @current_author.faq
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
	
	protected
	


end

