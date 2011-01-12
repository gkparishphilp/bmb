# == Schema Information
# Schema version: 20101120000321
#
# Table name: sites
#
#  id         :integer(4)      not null, primary key
#  author_id  :integer(4)
#  name       :string(255)
#  domain     :string(255)
#  status     :string(255)     default("active")
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
	
	#before_create	:set_domain_vhost
	before_validation :clean_domain
	#before_update	:set_domain_vhost
	
	validates :domain, :uniqueness => true
	
	has_many :roles
	has_many :admins, :through => :roles, :source => :user, :conditions => "role = 'admin'"
	has_many :contributors, :through => :roles, :source => :user, :conditions => "role = 'contributor'"
	
	has_many :articles, :as => :owner
	has_many :forums, :as => :owner
	has_many :podcasts, :as => :owner
	has_many :events, :as => :owner
	has_many :links, :as => :owner
	has_many :twitter_accounts, :as => :owner
	has_many :facebook_accounts, :as => :owner
	
	has_many :users
	has_many :static_pages
	has_many :contacts
	has_many :crashes
	
	belongs_to	:author
	
	does_activities
	
	def clean_domain
		self.domain.gsub!( /\Ahttp:\/\//, "" )
	end
	
	# private
	
	def set_domain_vhost
		# don't need to do this for non-author sites
		return unless self.author.present?
		
		path = File.join(Rails.root, 'assets/vhosts/')

		if self.domain_changed? and !self.domain.nil?
			write_file = File.join(path, self.domain)
			FileUtils.rm("#{path}#{self.domain_was}") if !self.domain_was.nil? and File.exists?("#{path}#{self.domain_was}")
			vhost_file = <<EOS
		server {
		       listen       80;
		       server_name #{self.domain};
			   root /data/vhosts/stage.rippleread.com/public;
		       passenger_enabled on;
		       rails_env development;

		       #charset koi8-r;

		       #access_log  logs/rippleread.access.log  main;

		   }
EOS
			File.open( write_file,"wb" ) { |f| f.write( vhost_file ) }
		
		end
	end

	def create_sigler_coupons
		a = Author.find_by_pen_name('Scott Sigler')
		c = Coupon.create :owner => a, :sku_id => 4, :code => 'aloha', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'aloha', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'aloha', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'chapman', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'chapman', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'chapman', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'evo', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'evo', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'evo', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'grammar', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'grammar', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'grammar', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'hutch', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'hutch', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'hutch', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'KATG', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'KATG', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'KATG', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'mur', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'mur', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'mur', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'podiobooks', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'podiobooks', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'podiobooks', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'seth', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'seth', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'seth', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1

		c = Coupon.create :owner => a, :sku_id => 4, :code => 'ginger', :description => 'Rookie Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 6, :code => 'ginger', :description => 'Starter Hardcover discount', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 12, :code => 'ginger', :description => 'Rookie and Starter Hardcover Combo discount', :discount_type => 'cents', :discount => 700, :redemptions_allowed => -1
		
	end
	
	def migrate_addresses
		# Migration for new address scheme
		orders = Order.all
		for order in orders
			if order.billing_address_id.present?  #CC orders only have billing address, not Paypal
				billing_address = BillingAddress.find( order.billing_address_id )
				unless Addressing.find_by_owner_id_and_owner_type_and_address_type( order.user.id, 'User', 'billing')
					new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(	
					 															:title => billing_address.title,
																				:first_name => billing_address.first_name,
																				:last_name => billing_address.last_name,
																				:street => billing_address.street,
																				:street2 => billing_address.street2,
																				:city => billing_address.city,
																				:geo_state_id => billing_address.geo_state.id,
																				:zip => billing_address.zip,
																				:country => billing_address.country,
																				:phone => billing_address.phone )
					new_geo_addy.save
					Addressing.create :owner_id => order.user.id, :owner_type => 'User', :geo_address_id => new_geo_addy.id, :address_type => 'billing'
				end
			end
			
			if order.shipping_address_id.present? #only merch orders have shipping addresses
				shipping_address = ShippingAddress.find( order.shipping_address_id)
				new_ship_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(
				 															:title => shipping_address.title,
																			:first_name => shipping_address.first_name,
																			:last_name => shipping_address.last_name,
																			:street => shipping_address.street,
																			:street2 => shipping_address.street2,
																			:city => shipping_address.city,
																			:geo_state_id => shipping_address.geo_state.id,
																			:zip => shipping_address.zip,
																			:country => shipping_address.country,
																			:phone => shipping_address.phone ) 
				Addressing.create :owner_id => order.user.id, :owner_type => 'User', :geo_address_id => new_ship_addy.id, :address_type => 'shipping'
			end
		end

		billing_addresses = BillingAddress.all
		for billing_address in billing_addresses
			if billing_address.user.present?
				unless Addressing.find_by_owner_id_and_owner_type_and_address_type(  billing_address.user.id, 'User', 'billing')
					new_geo_addy = TmpGeoAddress.find_or_initialize_by_street_and_first_name_and_last_name(	
					 															:title => billing_address.title,
																				:first_name => billing_address.first_name,
																				:last_name => billing_address.last_name,
																				:street => billing_address.street,
																				:street2 => billing_address.street2,
																				:city => billing_address.city,
																				:geo_state_id => billing_address.geo_state.id,
																				:zip => billing_address.zip,
																				:country => billing_address.country,
																				:phone => billing_address.phone )
					new_geo_addy.save
					Addressing.create :owner_id => billing_address.user.id, :owner_type => 'User', :geo_address_id => new_geo_addy.id, :address_type => 'billing'
				end
			end
		end
	end
	
end
