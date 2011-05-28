class AuthorsController < ApplicationController
	before_filter	:require_login, :except => [ :index, :show, :bio, :help, :signup ]
	before_filter	:get_form_data, :only => [:new, :edit]
	
	def index
		@author = Author.last
	end
	
	def upsell
		@author = @current_author
		render :layout => '3col'
	end
	
	def site_config
		@author = @current_author
		if @author.has_valid_subscription?( @marketing_subscription )
			render :layout => '3col'
		else
			pop_flash 'Please upgrade to access site customization options.', :error
			redirect_to :admin_index
		end
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
		params[:billing_address][:name] = params[:billing_address][:first_name] + ' ' + params[:billing_address][:last_name]
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
		@billing_address = @current_author.user.billing_address
		render :layout => '2col'
		
	end
	
	def update
		@author = Author.find params[:id]
		unless @current_author == @author
			pop_flash "Unauthorized", :error
			redirect_to root_path
			return false
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
		
		@skus = @author.skus.order( 'listing_order asc' )
		
		set_meta @author.pen_name, @author.bio
		
		@theme = @author.active_theme if @theme.nil? unless @author.nil? || @author.active_theme.nil?
		
	end
	
	def bio
		@author = Author.find params[:id] if @author.nil?
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
			@user = User.find_or_initialize_by_email params[:email]
			# todo - catch users who already have pws?
			if @user.hashed_password.blank?
				@user.attributes = { :password => params[:password], 
										:password_confirmation => params[:password_confirmation] }
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
				pop_flash "Something Good."

				redirect_to admin_index_url
			else
				pop_flash "There was a problem", :error, @user
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