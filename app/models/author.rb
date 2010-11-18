# == Schema Information
# Schema version: 20101110044151
#
# Table name: authors
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  featured_book_id   :integer(4)
#  pen_name           :string(255)
#  promo              :text
#  subdomain          :string(255)
#  domain             :string(255)
#  bio                :text
#  score              :integer(4)
#  cached_slug        :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  photo_updated_at   :datetime
#  photo_url          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Author < ActiveRecord::Base
	# represents writer of a book
	# may or may not belong to user
	
	before_create	:set_subdomain
	after_create	:create_default_campaign
	
	validate	:valid_subdomain
	
	has_many	:books
	belongs_to	:user
	
	has_many	:articles, :as => :owner
	has_many	:forums, :as => :owner
	has_many	:events, :as => :owner
	has_many	:podcasts, :as => :owner
	
	has_many	:merches, :as  => :owner
	has_many	:royalties
	has_many	:upload_email_lists
	has_many	:coupons, :as => :owner
	has_many	:coupons, :as => :redeemer
	has_many 	:redemptions, :as => :redeemer
	has_many	:email_subscribings, :as => :subscribed_to # This will list the author's subscribers, not what the author is subscribed to!
	has_many	:email_campaigns, :as => :owner
	has_many	:bundles, :as => :owner
	has_one		:theme
	
	does_activities
	
	has_friendly_id	:pen_name, :use_slug => true
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :profile => "250", :thumb => "64", :tiny => "20" }}
	
	def set_subdomain
		self.subdomain = self.pen_name.gsub(/\W/, "-").downcase
	end
	
	def create_default_campaign
		EmailCampaign.create!(:owner_type => self.class, :owner_id => self.id, :title => 'Default')
	end
	
	def promo_content
		#if self.promo =~ "book_1" #use book_bookid
		#podcast_1
		#event_1
		#blog_1
		#bio
		#or custom text in the field
		
		#default to bio
		return self.bio
	end
	
	
	def valid_subdomain
		if APP_SUBDOMAINS.include?( subdomain )
			errors.add :subdomain, "Invalid subdomain"
			return false
		end
	end
	
end
