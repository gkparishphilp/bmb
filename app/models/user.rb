require 'digest/sha1'

class User < ActiveRecord::Base
	# Constants    --------------------------------------
	ANONYMOUS_ID = 1

	# Filters		--------------------------------------
	before_create   :set_status
	before_save	 	:set_photo_url, :strip_website_url

  
	# Validations	--------------------------------------
	validates_uniqueness_of		:user_name, :case_sensitive => false

	validates_format_of			:user_name, :if => :old_school_user?,
										:with => /^[A-Za-z\s\d_-]+$/

	validates_confirmation_of	:password, :if => :old_school_user?
	validate					:password_non_blank, :if => :old_school_user?

	validates_format_of :email, :if => :has_email?,
                          :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i

	validates_uniqueness_of :email, :case_sensitive => false, :if => :has_email?

	# Relations   	--------------------------------------
	has_many	:openids
	has_and_belongs_to_many :roles
	has_many	:posts
	has_many	:comments
	has_one		:twitter_account, 	:as => :owner
	has_one		:facebook_account, 	:as => :owner
	
	has_one		:author
	
	# Plugins	--------------------------------------

	has_friendly_id   :user_name, :use_slug => :true

	has_attached_file :photo, :styles => {
	  :original  => "120x120#",
	  :thumb => "64x64#",
	  :tiny => "20x20#"
	}


	# Attribute accessors		------------------------------------
	attr_accessor	:password_confirmation

	# Class methods 	------------------------------------

	def self.authenticate( email, password )
		user = User.find_by_email( email )
		if user
			expected_password = encrypted_password( password, user.salt )
			if user.hashed_password != expected_password
				user = nil
			end
		end
		user
  	end

	def self.anonymous
		User.find ANONYMOUS_ID
	end

	# Instance Methods	------------------------------------
	#'password' is a virtual attribute i.e. not in the db
	def password
		@password
	end

	def password=(pwd)
		@password = pwd
		return if pwd.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end
  
	def has_role?(role)
		list ||= self.roles.map(&:name)
		list.include?(role.to_s) 
	end

	def anonymous?
		self.id == ANONYMOUS_ID
	end
  
	def logged_in?
		!self.anonymous?
	end
  
	def admin?
		self.has_role?('admin')
	end
  
	def contributor?
		self.has_role?('contributor')
	end
  
	def uploaded_photo?
		self.photo.exists?
	end
	
	def has_email?
		!self.email.blank?
	end
	
	def has_valid_email?
		!self.email.blank? && !self.activated_at.nil?
	end
	
	def avatar
		if self.uploaded_photo?
			return self.photo.url(:original)
		else
			return self.photo_url
		end
	end
	
	def create_activation_code
		self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
		self.save
	end
  
	#ruby attribute names can't end with question marks, only method names, so I'll
	#write my own attr_writer and a custom attr_reader that ends with a ?
	def human=(val)
		@human=val
	end
  
	def human?
		@human
	end
	
	# Stuff for user registration housekeeping --------------------------
  
	def create_remember_token
		self.remember_token = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
		self.remember_token_expires_at = 1.day.from_now
		self.save
	end


	def old_school_user?
		  self.openids.empty? && !self.twitter_user?
	end
	
	# Stuff for Twitter ------------------------------------------------

	########
	# Twitter Methods to register with Twitter and get a valid client session
	# for posting tweets, retrieving followers, etc., etc.
	def oauth
		@oauth ||= Twitter::OAuth.new( TWITTER_KEY, TWITTER_SECRET )
	end

	def client
		@client ||= begin
			oauth.authorize_from_access( self.twitter_account.token, self.twitter_account.secret )
			Twitter::Base.new(oauth)
		end
	end
	
	def self.create_from_twitter( profile, token, secret )
		name = profile.screen_name
		name = 'TW_' + profile.screen_name if User.find_by_user_name profile.screen_name
		
		user = User.new( :user_name => name, :photo_url => profile.profile_image_url )
		user.save( false )
		
		account = TwitterAccount.create(   :owner_id => user.id,
										:owner_type => 'User',
										:token => token,
										:secret  => secret,
										:twit_id => profile.id,
										:twit_name => profile.screen_name
		)
		return user
	end
	
	def twitter_user?
		!self.twitter_account.nil?
	end
	
	def tweet( message, url )
		chars_left = 136 - url.length
		message = message[0..chars_left] + (message.length > chars_left ? "..." : "")
		message += url
		
		tweet = self.client.update( message )
	end

protected

	def set_photo_url
		if  ( self.photo_url.blank? || self.photo_url ==  "/images/anon_user.jpg" ) && 
			!self.uploaded_photo?
			
			if self.email
				self.photo_url = "http://gravatar.com/avatar/" + Digest::MD5.hexdigest( self.email ) + "?d=wavatar"
			else
				self.photo_url = "/images/anon_user.jpg"
			end
		end
	end
	
	
	def set_status
		self.status = 'first' if self.status.nil?
	end
	
	
	def strip_website_url
		website_url.gsub!('http://', '') unless website_url.nil?
	end
	
	
	
private

	def password_non_blank
		errors.add(:password, "Missing Password") if hashed_password.blank?
	end

	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end

	def self.encrypted_password(pw, salt)
		string_to_hash = pw + "tryt945m43433492fgs4353zmte453" + salt
		Digest::SHA1.hexdigest(string_to_hash)
	end

	

end
