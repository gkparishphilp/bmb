class AuthorsController < ApplicationController
	cache_sweeper :author_sweeper, :only => [:create, :update, :destroy]
	before_filter	:require_login, :only => [ :edit, :edit_profile, :update ]
	before_filter	:get_form_data, :only => [:new, :edit]
	
	
	
	def index
		@author = Author.last
	end
	
	def platform_builder
		@author = @current_author
		render :layout => '2col'
	end
	
	def search
		@term = params[:q]
		@articles = @author.articles.search( @term ).published
		@skus = @author.skus.search( @term ).published
	end

	def manage
		@author = @current_user.author
		@campaign = @author.email_campaigns.find_by_title('Default')
		@all_assets = Array.new
		for book in @author.books
			for asset in book.assets
				@all_assets << asset
			end
		end
	end
	
	def new
		if @current_user.author?
			pop_flash "Already an Author", :notice
			redirect_to admin_index_path
			return false
		end
		@billing_address = GeoAddress.new( :address_type => 'billing' ) if @current_user.billing_address.nil?
		@author = Author.new
		@author.pen_name = @current_user.name
		@author.bio = @current_user.bio
		render :layout => 'application'
	end
	
	def create
		# Creating name from first name and last name
		if params[:billing_address]
			params[:billing_address][:name] = params[:billing_address][:first_name] + ' ' + params[:billing_address][:last_name]
			params[:billing_address][:address_type] = 'billing'
		end
		@author = Author.new params[:author]
		@author.user = @current_user
		@author.user.billing_address = GeoAddress.new params[:billing_address]
		
		if @author.save && @author.user.billing_address.save
			process_attachments_for( @author )
			pop_flash "Author Profile Created"
			redirect_to admin_index_path
		else
			pop_flash "Ooops, there was a problem saving the profile", :error, @author
			redirect_to :back
		end
	end
	
	def edit
		@author = @current_author
		@billing_address = @current_author.user.billing_address || @current_author.user.build_billing_address
		# Stupid transformations to get first and last names separate for form.  Next time, we have first and last names as separate fields
		if @billing_address.name.present?
			@billing_address.first_name = @billing_address.name.split(/ /).first
			@billing_address.last_name = @billing_address.name.split(/ /).last
		end
		@subscriptions = @current_author.user.subscribings.active
		render :layout => '2col'
		
	end
	
	def edit_profile
		@author = @current_author
		render :layout => '2col'
	end
	
	def newsletter_signup
		@author = Author.find( params[:id] )
		
		user = User.find_or_initialize_by_email( params[:email] )
		user.name = params[:name].gsub( /\W/, "_" )

		if user.save
			subscribing = EmailSubscribing.find_or_create_subscription( @author, user)  
			subscribing.update_attributes :status => 'subscribed' 
		else
			pop_flash 'There was an error: ', :error, user
			redirect_to :back
			return false
		end
		
		pop_flash "Thank you for signing up for the #{@author.pen_name} newsletter!"
		redirect_to :back
		
	end
	
	def update
		@author = Author.find params[:id]
		unless @current_author == @author
			pop_flash "Unauthorized", :error
			redirect_to root_path
			return false
		end
		
		#Set up params for saving billing address if it exists (like from updating the Author Account information page in Admin) 
		#Need to clean this up, there has to be a better way
		if params[:billing_address]
			params[:billing_address][:name] = params[:billing_address][:first_name] + ' ' + params[:billing_address][:last_name]
			params[:billing_address][:address_type] = 'billing'
			@author.user = @current_user
			@author.user.billing_address = GeoAddress.new params[:billing_address]
			@author.user.billing_address.save
		end
		
		if @author.update_attributes params[:author] 
			process_attachments_for( @author )
			pop_flash "Author Profile Updated!"
		else
			pop_flash "Profile could not be saved", :error, @author
		end
		redirect_to admin_index_path
	end
	
	def show 
		@author = Author.find params[:id] if @author.nil?
		
		if @author.nil?
			pop_flash "No author found", :notice
			redirect_to root_path
		end
		
		@skus = @author.skus.order( 'listing_order asc' ).limit( 3 )
		
		set_meta @author.pen_name, @author.bio
		
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
		
		if @author.books.published.empty? && @author.articles.published.empty?
			render 'under_construction' 
			return false
		end
		
		if @author.skus.present?
			redirect_to author_store_index_path( @author )
		elsif @author.articles.published.present?
			redirect_to author_blog_index_path( @author )
		else
			redirect_to author_books_path( @author )
		end
		
	end
	
	
	def bio
		@author = Author.find params[:id] if @author.nil?
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
	end
	
	def contact
		@author = Author.find( params[:id] )
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
	end
	
	def help
		@author = Author.find params[:id] if @author.nil?
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
	end
	
	def signup
		if request.post?
			if params[:email].blank?
				pop_flash "Email is required", :error
				redirect_to :back
				return false
			end
			if params[:pen_name].blank?
				pop_flash "Pen Name is required", :error
				redirect_to :back
				return false
			end
			if params[:password].blank?
				pop_flash "Password is required", :error
				redirect_to :back
				return false
			end

			@user = User.find_or_initialize_by_email params[:email]
			# todo - catch users who already have pws?
			if @user.hashed_password.blank?
				@user.attributes = { :password => params[:password], 
										:password_confirmation => params[:password_confirmation],
										:name => params[:pen_name].gsub(/\W/, "_") }
			end

			@user.orig_ip = request.ip

			@user.status = 'pending'
			@user.site = @current_site
			
			@user.website_url = params[:website] unless params[:website].blank?
	
			if @user.save
			
				@user.create_activation_code
				@user.reload
			
				#email = UserMailer.author_welcome( @user, @current_site ).deliver
				login( @user )
				
				author = Author.create :user_id => @user.id, :pen_name => params[:pen_name]
				
				if params[:agreement]
					contract = Contract.first
					agreement = ContractAgreement.new :author => author, :contract => contract
					agreement.save
				end
				
				pop_flash "Thank you for registering."

				redirect_to admin_index_url
			else
				pop_flash "There was a problem", :error, @user
				redirect_to :back
			end

		else
			render :layout => 'application'
		end
	end
	
	private

	def get_form_data
		@months = {'01' => 1, '02' => 2, '03' => 3, '04' => 4, '05' => 5, '06' => 6, '07' => 7, '08' => 8, '09' => 9, '10' => 10, '11' => 11, '12' => 12 }.sort
		@years = {'2010' => 2010, '2011' => 2011, '2012' => 2012, '2013' => 2013, '2014' => 2014, '2015' => 2015, '2016' => 2016,  '2017' => 2017,  '2018' => 2018,  '2019' => 2019,  '2020' => 2020 }.sort
		@countries = GeoCountry.where( "id < 4").all + [ GeoCountry.new( :id => nil, :name => "-----------") ] + GeoCountry.order("name asc" ).all
	end
	
	
	
end