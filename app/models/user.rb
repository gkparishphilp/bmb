# == Schema Information
# Schema version: 20110826004210
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  site_id                   :integer(4)
#  email                     :string(255)
#  name                      :string(255)
#  score                     :integer(4)      default(0)
#  website_name              :string(255)
#  website_url               :string(255)
#  bio                       :text
#  hashed_password           :string(255)
#  salt                      :string(255)
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  activation_code           :string(255)
#  activated_at              :datetime
#  status                    :string(255)     default("first")
#  cached_slug               :string(255)
#  name_changes              :integer(4)      default(3)
#  tax_id                    :string(255)
#  orig_ip                   :string(255)
#  last_ip                   :string(255)
#  paypal_id                 :string(13)
#  created_at                :datetime
#  updated_at                :datetime
#

require 'digest/sha1'

class User < ActiveRecord::Base
	# Constants    --------------------------------------
	ANONYMOUS_ID = 1

	# Filters		--------------------------------------
	before_save	 	:strip_website_url, :set_name
	after_create	:set_avatar
  
	# Validations	--------------------------------------
	validates	:password, :confirmation => true, :length => { :minimum => 4, :maximum => 254 }, :if => :has_password?

	validates	:email, :uniqueness => true, 
						:length => {:minimum => 3, :maximum => 254},
						:email => true,
						:if => :has_email?

	validates	:name, :uniqueness => true, 
						:length => {:minimum => 2, :maximum => 254},
						:if => :has_name?



	# Relations   	--------------------------------------
	has_many	:openids
	has_many	:roles
	has_many	:admin_sites, :through => :roles, :source => :site, :conditions => "role = 'admin'"
	has_many	:contributor_sites, :through => :roles, :source => :site, :conditions => "role = 'contributor'"
	has_many	:posts
	has_many	:comments
	has_many	:twitter_accounts, 	:as => :owner
	has_many	:facebook_accounts,	:as => :owner
	
	has_many	:geo_addresses
	has_many	:shipping_addresses, :class_name => 'GeoAddress', :conditions => "address_type='shipping'"
	has_one		:billing_address, :class_name => 'GeoAddress', :conditions => "address_type='billing'"
	
	accepts_nested_attributes_for	:billing_address, :shipping_addresses
	
	has_one		:author
	accepts_nested_attributes_for	:author
	
	
	has_many	:orders
	has_many	:reviews
	has_many	:subscribings
	has_many	:subscriptions, :through => :subscribings
	has_many	:coupons
	has_many	:redemptions
	has_many	:email_subscribings, :as => :subscriber
	has_many	:ownings
	has_many	:skus, :through => :ownings
	has_many	:coupons
	has_many	:email_messages, :as => :sender
	has_many	:email_messages
	
	belongs_to :site
	
	# Plugins	--------------------------------------
	has_friendly_id   :name, :use_slug => :true

	has_attached :avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => {
				:profile  => "120",
				:thumb => "64",
				:tiny => "20"
				}}
	
	acts_as_follower
	does_activities
	liquid_methods :name

	# Attribute accessors		------------------------------------
	attr_accessor	:password_confirmation

	# Class methods 	------------------------------------

	def self.authenticate( id, password )
		# going to tweak this to return the user(or false) along with a status msg
		# so, new use will be user, msg = User.authenticate( email, password )
		# also going to add the ability to login by username in addition to email
		user = User.find_by_email( id ) || User.find_by_name( id )
		
		if user.nil?
			return user, "Invalid user/password combination"
		elsif not user.registered?
			return false, "User not registered"
		else
			expected_password = encrypted_password( password, user.salt )
			if user.hashed_password != expected_password
				user = nil
				return user, "Invalid user/password combination"
			end
		end
		
		return user, "#{user.email} successfully logged in"
		
  	end

	def self.anonymous
		User.find ANONYMOUS_ID
	end

	# Instance Methods	------------------------------------
	
	# For sessions / Validations, etc..
	
	def anonymous?
		self.id == ANONYMOUS_ID
	end
	
	def create_activation_code
		self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
		self.save
	end
	
	def create_remember_token
		self.remember_token = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
		self.remember_token_expires_at = 1.day.from_now
		self.save
	end
	
	def has_email?
		!self.email.blank?
	end
	
	def has_name?
		self.name.present?
	end
	
	def has_password?
		self.password.present?
	end
	
		#ruby attribute names can't end with question marks, only method names, so I'll
		#write my own attr_writer and a custom attr_reader that ends with a ?
	def human=(val)
		@human=val
	end
  
	def human?
		@human
	end
	
	def logged_in?
		!self.anonymous?
	end
	
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
	
	def registered?
		self.hashed_password.present?
	end
	
	def spammer?
		self.status == 'spammer'
	end
	
	def validated?
		!self.email.blank? && !self.activated_at.nil?
	end
	
	
	# For permissions / Roles
	
	def admin?( site )
		site.admins.include? self
	end
	
	def contributor?( site )
		contribs = site.contributors + site.admins
		contribs.include? self
	end
	
	def make_admin( site )
		return false if self.author?
		r = Role.create :user_id => self.id, :site_id => site.id, :role => 'admin'
	end
	
	def make_contributor( site )
		r = Role.create :user_id => self.id, :site_id => site.id, :role => 'contributor'
	end
	
	def make_site_role( site, role )
		r = Role.create :user_id => self.id, :site_id => site.id, :role => role
	end
	
	def make_author
		author = Author.create :user_id => self.id, :pen_name => self.name
	end
	
	def comp_subscription( sub )
		Subscribing.create :subscription_id => sub.id, :user_id => self.id, :profile_id => 'comp', :status => 'ActiveProfile', :origin => 'comp'
	end
	
	# Stuff for Social Media ---------------------------------------------
		# Facebook -------------------------------------------------
	def facebook_user?
		!self.facebook_accounts.empty?
	end
	
	def social_accounts
		self.twitter_accounts + self.facebook_accounts
	end
	
		# Twitter --------------------------------------------------
	def twitter_user?
		!self.twitter_accounts.empty?
	end
	
	# App-specific
	def author?
		!self.author.nil?
	end
	
	def owns?( sku )
		for owning in self.ownings
			return true if owning.sku == sku
		end
		return false
	end

	protected

	def set_avatar
		if self.has_email? && self.avatar.nil?
			photo_url = "http://gravatar.com/avatar/" + Digest::MD5.hexdigest( self.email ) + "?d=identicon"
			pic = Attachment.create( :path => photo_url, :attachment_type => 'avatar', :owner => self, :remote => true, :format => 'jpg' )
		end
	end
	
	def strip_website_url
		website_url.gsub!('http://', '') unless website_url.nil?
	end
	
	def set_name
		self.name = self.email.gsub(/\W/, "_") unless self.name.present?
	end
	
	
	
private

	def password_non_blank
		errors.add(:password, "Missing Password") if hashed_password.blank?
	end

	def create_new_salt
		self.salt = self.object_id.to_s + rand.to_s
	end

	def self.encrypted_password(pw, salt)
		string_to_hash = pw + "439fgfg334gergersd9fhq34ufq" + salt
		Digest::SHA1.hexdigest(string_to_hash)
	end

	

end
