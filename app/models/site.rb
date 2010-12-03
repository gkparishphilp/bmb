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
	
	gets_activities
	
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
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'aloha', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'aloha', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'chapman', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'chapman', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'evo', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'evo', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'grammar', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'grammar', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'hutch', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'hutch', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'KATG', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'KATG', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'mur', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'mur', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'podiobooks', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'podiobooks', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'seth', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'seth', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 15, :code => 'ginger', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		c = Coupon.create :owner => a, :sku_id => 16, :code => 'ginger', :description => '', :discount_type => 'cents', :discount => 300, :redemptions_allowed => -1
		
	end
end
