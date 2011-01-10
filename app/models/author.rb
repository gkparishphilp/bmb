# == Schema Information
# Schema version: 20101120000321
#
# Table name: authors
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  featured_book_id :integer(4)
#  pen_name         :string(255)
#  promo            :text
#  subdomain        :string(255)
#  bio              :text
#  score            :integer(4)
#  cached_slug      :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Author < ActiveRecord::Base
	# represents writer of a book
	# may or may not belong to user
	
	before_create	:set_subdomain#, :set_domain_vhost
	after_create	:create_default_campaign
	#before_update	:set_domain_vhost
	
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
	has_many	:email_subscribings, :as => :subscribed_to # This will list the author's subscribers, not what the author is subscribed to!
	has_many	:email_campaigns, :as => :owner
	has_many	:links, :as => :owner
	has_many	:skus, :as => :owner
	
	has_many	:theme_ownings
	has_many	:themes, :through => :theme_ownings
	has_one		:active_theme, :through => :theme_ownings, :source => :theme, :conditions => "active = true"
	
	has_many	:sites
	
	has_many	:addressings, :as => :owner
	has_many	:geo_addresses, :through => :addressings
	has_one		:nexus_address, :through => :addressings, :source => :geo_address, :conditions => "address_type='nexus'"
	
	does_activities
	
	has_friendly_id	:pen_name, :use_slug => true
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :profile => "250", :thumb => "64", :tiny => "20" }}
	
	# todo return effective royalty rate depending on author's subscriptions
	def current_royalty_rate
		# todo fix this ghetto shit!!!!!!
		return 90
	end
	
	def owner
		return self
	end
	
	def name
		return self.pen_name
	end
	
	def assets
		# return all assets for all books for the author
		self.books.collect{ |b| b.assets }.flatten
	end
	
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
		if self.promo.blank?
			return self.bio
		elsif self.promo =~ /\Abook_/
			return book_promo
		else
			return self.promo.html_safe
		end
	end
	
	def orders
		orders = Array.new
		for order in Order.all
			orders << order if order.sku.owner == self
		end
	end
	
	private
	
	def book_promo
		id = self.promo.split( /_/ )[1]
		book = Book.find( id.to_i )
		str = "I'm Promoting #{book.title}!!!!"

		return str.html_safe
	end
	
	def valid_subdomain
		if APP_SUBDOMAINS.include?( subdomain )
			errors.add :subdomain, "Invalid subdomain"
			return false
		end
	end
	
	
end
