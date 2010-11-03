require 'digest/sha1'

class User < ActiveRecord::Base
	# Constants    --------------------------------------
	ANONYMOUS_ID = 1

	# Filters		--------------------------------------
	before_save	 	:set_photo_url_for_gravatar, :strip_website_url

  
	# Validations	--------------------------------------
	validates	:name, :presence => true

	validates	:password, :confirmation => true, :length => {:minimum => 4, :maximum => 254}, :if => :old_school_user?

	validates	:email, :uniqueness => true, 
						:length => {:minimum => 3, :maximum => 254},
						:email => true,
						:if => :has_email?

	# Relations   	--------------------------------------
	has_many	:openids
	has_many	:roles
	has_many	:admin_sites, :through => :roles, :source => :site, :conditions => "role = 'admin'"
	has_many	:contributor_sites, :through => :roles, :source => :site, :conditions => "role = 'contributor'"
	has_many	:posts
	has_many	:comments
	has_many	:twitter_accounts, 	:as => :owner
	has_many	:facebook_accounts,	:as => :owner
	has_many 	:shipping_addresses
	has_many	:billing_addresses
	has_one		:author
	has_many	:orders
	has_many	:subscribings
	has_many	:subscriptions, :through => :subscribings
	has_many	:coupons, :as => :redeemer
	
	belongs_to :site
	
	# Plugins	--------------------------------------

	has_friendly_id   :name, :use_slug => :true

	has_attached_file :photo, :styles => {
	  :original  => "120x120#",
	  :thumb => "64x64#",
	  :tiny => "20x20#"
	}
	
	acts_as_follower
	does_activities


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

	def anonymous?
		self.id == ANONYMOUS_ID
	end
  
	def logged_in?
		!self.anonymous?
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
	
	def make_site_role( site, role )
		r = Role.create :user_id => self.id, :site_id => site.id, :role => role
	end
	
	def make_admin( site )
		r = Role.create :user_id => self.id, :site_id => site.id, :role => 'admin'
	end
	
	def make_contributor( site )
		r = Role.create :user_id => self.id, :site_id => site.id, :role => 'contributor'
	end
	
	def admin?( site )
		site.admins.include? self
	end
	
	def contributor?( site )
		contribs = site.contributors + site.admins
		contribs.include? self
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


	
	# Stuff for Social Media ---------------------------------------------
	def social_accounts
		self.twitter_accounts + self.facebook_accounts
	end

	def old_school_user?
		self.social_accounts.empty?
	end
	
	# Stuff for Twitter --------------------------------------------------
	def twitter_user?
		!self.twitter_accounts.empty?
	end
	
	# Stuff for Facebook -------------------------------------------------
	def facebook_user?
		!self.facebook_accounts.empty?
	end

protected

	def set_photo_url_for_gravatar
		if  ( self.photo_url.blank? || self.photo_url ==  "/images/anon_user.jpg" ) && 
			!self.uploaded_photo?
			
			if self.email
				self.photo_url = "http://gravatar.com/avatar/" + Digest::MD5.hexdigest( self.email ) + "?d=identicon"
			else
				self.photo_url = "/images/anon_user.jpg"
			end
		end
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
