class UsersController < ApplicationController
	before_filter   :require_admin,   :only => [ :admin, :destroy ]

	def admin
		@users = User.all.paginate :page => params[:page], :per_page => 25
	end
	
	def show
		@user = User.find(params[:id])
		if @user.anonymous?
			flash[:notice] = "Invalid User"
			redirect_to root_path
			return false
		end

		# first things first, public or private?
		if @user == @current_user
			if @user.author?
				render :private_author, :layout => '2col'
			else
				render :private
			end
		else 
			if @user.author?
				redirect_to author_url( @user.author )
			else
				# Let's just show the public profile
				set_meta @user.name, @user.bio
				render	:public
			end
		end
	end


	def edit
		@user = User.find params[:id] 
		@countries = GeoCountry.where( "id < 4").all + [ GeoCountry.new( :id => nil, :name => "-----------") ] + GeoCountry.order("name asc" ).all
		if @current_user.anonymous?
			flash[:notice] = "Can't edit this user"
			redirect_to root_path
			return false
		end

		#if @user != @current_user || !@current_user.admin?( @current_site )
		#	flash[:notice] = "Can't edit this user"
		#	redirect_to root_path
		#	return false
		#end
		
		@billing_address =  @user.billing_address.present? ?  @user.billing_address : GeoAddress.new( :address_type => 'billing' )
		@user.shipping_addresses.build
		
		@states = GeoState.where("country ='US'")
    
	end

	def create
		@user = User.find_or_initialize_by_email params[:user][:email]
		if @user.hashed_password.present?
			pop_flash "An account exists for this email -- please login", :notice
			redirect_to login_path( :email => @user.email )
			return false
		else
			# this is a brand-new user, whether we found an email or not
			@user.attributes = params[:user]
		end
		
	
		@user.orig_ip = request.ip

		@user.status = 'pending'
		@user.site = @current_site
	
		if @user.save
			
			@user.create_activation_code
			@user.reload
						
			pop_flash "User was successfully created."
			
			@user.did_join @current_site
			
			login( @user )

			redirect_to @user

		else
			pop_flash 'Ooops, User not saved.... ', 'error', @user
			redirect_to register_path
		end

	end

	def update
		@user = User.find params[:id] 
		
		if @user.update_attributes( params[:user] )
			process_attachments_for( @user )
			pop_flash 'User was successfully updated.'	
		else
			pop_flash 'Oooops, User not updated...', 'error', @user
		end
		
		redirect_to request.env['HTTP_REFERER']
	end

	def destroy
		@user = User.find params[:id]
		@user.destroy
	end
  
	def forgot_password
		if request.post?
			@user = User.find_by_email( params[:email] )
			if @user
				@user.create_remember_token
				@user.reload

				email = UserMailer.forgot_password( @user, @current_site ).deliver
				pop_flash "Email sent to #{@user.email}.Please follow the enclosed instructions to recover your password.", :notice
				redirect_to root_path
			else
				params[:email] = nil
				pop_flash "No user with that email.", :error
			end
		end
	end
  
	def reset_password
		if !session[:user_id].nil?
			# a user is logged in, 
			@user = User.find session[:user_id]
		elsif params[:token]
			valid_token_user = User.find_by_remember_token params[:token]  #can add date expiry later
			if !valid_token_user
				pop_flash "Invalid password reset token", :error
				redirect_to :controller => "session", :action => "new"
				return false
			end
			@user = valid_token_user
		else
			pop_flash "No access without credential", :error
			redirect_to :controller => "session", :action => "new"
			return false
		end
      
		if request.post?
			if (params[:password] == params[:password_confirmation] && !params[:password].empty? )
				@user.password = params[:password]
				@user.remember_token = nil
				@user.save!
				flash[:notice] = "Password updated"
  
				#just in case we're coming from forgot pw / email flow
				login( @user )
				redirect_to @user
			else
				pop_flash "Passwords must match", :error
			end
		end
	end

	def update_password
		current_password = params[:current_password]
		new_password = params[:new_password]
		new_password_confirmation = params[:new_password_confirmation]
		
		if @current_user != User.authenticate( @current_user.email, current_password )
			pop_flash "Current Password Incorrect", :error
			redirect_to settings_path
			return false
		elsif new_password != new_password_confirmation
			pop_flash "Password Confirmation Incorrect", :error
			redirect_to settings_path
			return false
		else
			@current_user.password = new_password
			@current_user.save
			pop_flash "Password Updated"
			redirect_to settings_path
		end
		
	end

	def activate
		activ_code = params[:token] || "none"
		valid_user = User.find_by_activation_code( activ_code )

		if !valid_user
			pop_flash "Invalid activation code", :error
			redirect_to root_path
			return false
		else
			pop_flash "Your account has been activated"
			valid_user.update_attributes :status => 'first', :activated_at => Time.now
		
			login( valid_user )
			
			redirect_to valid_user
		end
	end
	
	def resend
		@user = User.find params[:id]
		email_args = { :user => @user }
		email = UserMailer.welcome( @user, @current_site ).deliver
		flash[:notice] = "An Email has been sent to #{@user.email}.  Please follow the enclosed instructions to fully activate your account."
		
		redirect_to pending_sessions_path( :user_id => @user.id )
	end
	
	def comp_platform_builder
		@user = User.find params[:id]
		if 	@user.make_author
			@user.comp_subscription( Subscription.platform_builder )
			pop_flash "User is now an author", :success
		else
			pop_flash "Can't make user into author", :error
		end
		
		redirect_to :back
	end

end









