# == Schema Information
# Schema version: 20110606205010
#
# Table name: orders
#
#  id                      :integer(4)      not null, primary key
#  user_id                 :integer(4)
#  shipping_address_id     :integer(4)
#  billing_address_id      :integer(4)
#  sku_id                  :integer(4)
#  email                   :string(255)
#  ip                      :string(255)
#  status                  :string(255)
#  paypal_express_token    :string(255)
#  paypal_express_payer_id :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  tax_amount              :integer(4)
#  shipping_amount         :integer(4)
#  total                   :integer(4)
#  comment                 :text
#  sku_quantity            :integer(4)      default(1)
#

class Order < ActiveRecord::Base
	belongs_to	:user
	belongs_to	:sku
	has_one		:order_transaction, :dependent => :destroy
	has_one		:refund
	has_one		:redemption
	has_one		:coupon, :through => :redemption
	has_one		:subscribing
	
	has_many	:royalties
	has_many	:email_messages, :as => :source
	
	belongs_to		:shipping_address, :class_name => 'GeoAddress', :foreign_key => :shipping_address_id
	belongs_to		:billing_address, :class_name => 'GeoAddress', :foreign_key => :billing_address_id
	
	
	attr_accessor	:payment_type, :card_number, :card_cvv, :card_exp_month, :card_exp_year, :card_type, :periodicity, :subscribe_to_author
	liquid_methods	:email, :created_at, :user, :order_transaction, :sku, :shipping_address, :comment, :sku_quantity
	
	# adding for 12/4 fixpass....
	scope :successful, joins( "join order_transactions on order_transactions.order_id = orders.id" ).where( "order_transactions.success = 1" )
	
	scope :dated_between, lambda { |*args| 
		where( "orders.created_at between ? and ?", (args.first.to_date || 7.days.ago.getutc), (args.second.to_time || Time.now.getutc) ) 
	}

	scope :for_author, lambda { |args|
		joins( "join skus on skus.id = sku_id " ).where( "skus.owner_type='Author' and skus.owner_id = ?", args )
	}
	
	scope :for_sku, lambda {|args|
		where("sku_id = ?", args)
	}
	
	scope :has_shipping_amount, where("orders.shipping_amount > 0")
	
	scope :not_refunded, where("orders.status <> 'refunded' ")
	
	scope :to_be_shipped, where("orders.shipping_amount > 0 and orders.status <> 'refunded'")
	
#---------------------------------------------------------------
# Validations
#---------------------------------------------------------------
	validate_on_create	:validate_card, :validate_billing_address
	
	# adding for 12/4 fixpass....
	validate_on_create :validate_unique_order, :validate_available_quantity
	
	validates :email, :presence => true, :format => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i 
	
	def successful?
		self.order_transaction.success ? (return true) : (return false) 
	end
	
	def author_subscription?
		self.sku == Subscription.platform_builder.sku
	end
	
	def owner
		# aliases back to the owner of the stuff that was sold e.g. the author
		return self.sku.items.first.owner
	end
	
	def contains_files?
		# meaning, no merch
		return self.sku.contains_etext? || self.sku.contains_audio?
	end
	
	def contains_merch?
		return self.sku.contains_merch?
	end

	def self.search( term )
		if term
			term = "%" + term + "%"
			self.joins( :order_transaction, :user ).where( "order_transactions.reference like :term OR users.email like :term OR orders.email like :term ", :term => term )
		else
			return scoped
		end
	end
	
	def paypal_express?
		return self.paypal_express_token.present?
	end
	
	def get_paypal_express_details
		paypal_express_details = EXPRESS_GATEWAY.details_for( self.paypal_express_token )
	end

#---------------------------------------------------------------
# Apply coupon to order
#---------------------------------------------------------------

	def apply_coupon( coupon )
		case discount_type=coupon.discount_type
			when 'percent'
				self.total = (self.total - (coupon.discount/100.0 * self.total)).round 
			when 'cents'
				self.total = self.total - (coupon.discount * self.sku_quantity)
		end	
		self.total = 0 if self.total < 0
	end

	def redeem_coupon( coupon )
		# Mark a coupon as redeemed in the redemptions table
		redemption = Redemption.new
		redemption.user = self.user
		redemption.order = self
		redemption.coupon = coupon
		redemption.status = 'redeemed'
		redemption.save
	end

	def item_price
		# Return the price of the order, after the coupon has been applied to it.
		# Used for refund calculations to take into account coupons
		if self.coupon.present?
			if self.coupon.discount_type == 'cents'
				item_price = (self.sku.price - self.coupon.discount) * self.sku_quantity
			elsif self.coupon.discount_type == 'percent'
				item_price = self.sku_quantity * (self.sku.price - (coupon.discount/100.0 * self.sku/price)).round  
			else
				item_price = self.sku.price * self.sku_quantity
			end
		else 
			item_price = self.sku.price * self.sku_quantity
		end
		return item_price
	end

#-------------------------------------------------------------------------
# Method calling Paypal Gateways for purchases  (regular,express, and subscription)
#-------------------------------------------------------------------------
	# Call Paypal and get response object
	def purchase
		if self.sku.sku_type == 'subscription'
			purchase_subscription
		else
			if self.total > 0
				response = process_purchase
				OrderTransaction.create!(	:action => "purchase",
											:order_id => self.id,
											:price => self.total, 
											:success => response.success?, 
											:reference => response.authorization,
											:message => response.message,
											:params => response.params,
											:test => response.test? 
											)
				response.success?
			elsif self.total == 0
				OrderTransaction.create!( 	:action => "purchase",
											:order_id => self.id,
											:price => self.total, 
											:success => true, 
											:reference => 'BackMyBook coupon purchase',
											:message => 'zero price purchase'
											)
				return true			
			else
				false
			end
		end
	end
	

#------------------------------------------------------------------
# Methods calling Paypal Gateways for subscriptions
#------------------------------------------------------------------
# Subscriptions can NEVER be charged to Paypal at a price of zero or less.  Make a direct entry into the subscribings model if it is a free subscription.
# Comped subscriptions should have the subscription_length_in_days value set, paid subscriptions should not have this set since Paypal uses periodicity	

	def purchase_subscription
		if self.total > 0
			response = GATEWAY.recurring(self.total, credit_card, options_recurring)
			OrderTransaction.create!(	:action => "subscription",
			 							:order_id => self.id,
										:price => self.total, 
										:success => response.success?, 
										:reference => response.authorization,
										:message => response.message,
										:params => response.params,
										:test => response.test? 
										)

			if response.success?
				#todo check the subscription_id setting
				Subscribing.create!(	:user_id => self.user.id,
										:order_id => self.id,
										:subscription_id  => self.sku.sku_items.first.item.id,
										:status => 'ActiveProfile',
										:profile_id => self.order_transaction.params["profile_id"],
										:origin => 'paid',
										:start_date => options_recurring[:starting_at]
									)
			end

			response.success?
		else
			return false		
		end
	end

	
	def cancel_paypal_subscription 
		response = GATEWAY.cancel_recurring( self.subscribing.profile_id )
		self.subscribing.update_attributes! :status => 'CancelledProfile' if response.success?
		return response.success?	
	end
	
#------------------------------------------------------------------
# Actions taken before sending order to merchant processing gateway
# For example, calculating tax, calculating shipping, etc.
#------------------------------------------------------------------

	def calculate_taxes
		tax = 0
		
		if self.sku.contains_merch?
			# because paypal orders will not have billing addresses, just set 
			# billing == to shipping if billing_address is nil
			self.billing_address ||= self.shipping_address 
			
			tax = (self.sku.price * self.tax_rate * self.sku_quantity).round if self.billing_address.state == self.nexus
		end
		
		self.tax_amount = tax
		
	end

	def nexus
		return self.sku.owner.user.billing_address.state
	end

	def tax_rate
		if self.billing_address.state == self.nexus
			tax_rate = TaxRate.find_by_geo_state_abbrev( self.nexus ).rate
		else
			return 0
		end
	end
	
	def calculate_shipping
		shipping_price = 0
		
		if self.sku.contains_merch?
			# Author should have at least one billing address
			author_country = self.sku.owner.user.billing_address.country
		
			# Determine country of order
			order_country = self.shipping_address.country

			order_country == author_country ? shipping_price = self.sku.domestic_shipping_price * self.sku_quantity : shipping_price = self.sku.international_shipping_price * self.sku_quantity
		
			shipping_price ||= 0 
		end
		
		self.shipping_amount = shipping_price
	end

#---------------------------------------------------------------
# Actions after a successful order transaction
#---------------------------------------------------------------

	def send_author_emails
		UserMailer.fulfill_order( self, self.user ).deliver if self.sku.contains_merch?
	end

	def send_customer_emails
		if self.sku.sku_type == 'subscription'
			UserMailer.bought_subscription( self, self.user ).deliver
		else
			UserMailer.bought_sku( self, self.user ).deliver 
		end
	end

	def calculate_royalties
		unless self.sku.owner_type == 'Site'	
			self.royalties.create :author_id => self.sku.owner.id, :amount => ( self.total * ( self.sku.owner.current_royalty_rate.to_f / 100 ) ).round
		end
	end

	def update_backings
	end

	def update_author_points
	end

  private

	# Get royalty percentage
	def get_max_royalty_percentage
		#todo recalculate based on sku's
		royalty = 0
		for sub in self.ordered.subscriptions.active.royalty_percentages
			royalty = sub.royalty_percentage if sub.royalty_percentage > royalty
		end	
		return royalty
	end
	
	# Set up credit card object for gateway call
	def credit_card
		@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
			:type => card_type,
			:number => card_number,
			:verification_value => card_cvv,
			:month => card_exp_month,
			:year => card_exp_year,
			:first_name => self.billing_address.name.split(' ').first,
			:last_name => self.billing_address.name.split(' ').last
			)
	end

	# Use regular gateway or Paypal express gateway based on token
	def process_purchase
		if paypal_express_token.blank?
			GATEWAY.purchase(self.total, credit_card, options)
		else
			EXPRESS_GATEWAY.purchase(self.total, options_express)
		end
	end

#------------------------------------------------------------------------
# Set up options hash for different types of payment calls to Paypal Gateways
#------------------------------------------------------------------------
	#Set up options hash for regular Paypal gateway call 
	def options
		@options = {
			:ip => ip,
			:email => self.email,
			:description => "Author: #{self.sku.items.first.owner.id} #{self.sku.items.first.owner.pen_name}  SKU: #{self.sku.id} #{self.sku.title}",
			:billing_address => {
				:name => self.billing_address.name,
				:address1 => self.billing_address.street,
				:address2 => self.billing_address.street2,
				:city => self.billing_address.city,
				:state => self.billing_address.state,
				:zip => self.billing_address.zip,
				:country => self.billing_address.country,
				:phone => self.billing_address.phone
			}
		}
	end
		
	#Set up options hash for Paypal Express gateway call 
	def options_express
		@options_express = {
			:ip => ip,
			:token => paypal_express_token,
			:payer_id => paypal_express_payer_id
		}	
	end
	
	#Set up options hash for Paypal subscription gateway call
	def options_recurring
		if self.sku.sku_items.first.item.periodicity == 'daily'
			period = :daily
		elsif self.sku.sku_items.first.item.periodicity == 'weekly'
			period  = :weekly
		elsif self.sku.sku_items.first.item.periodicity == 'monthly'
			period = :monthly
		elsif self.sku.sku_items.first.item.periodicity == 'yearly'
			period = :yearly
		elsif self.sku.sku_items.first.item.periodicity == 'quarterly'
			period = :quarterly
		else
			period = :monthly
		end
		
		#Determine end of trial period/first time subscription is billed
		if self.sku.items.first.trial_length_in_days
			start_time = (Time.now + self.sku.items.first.trial_length_in_days.days).utc
		else
			start_time = Time.now.utc
		end
		
		@options = {
			:ip => ip,
			:periodicity => period,
			:email => self.email,
			:comment => self.sku.description,
			:starting_at => start_time.strftime("%Y-%m-%dT%H:%M:%SZ"),
			:billing_address => {
				:name => self.billing_address.name,
				:address1 => self.billing_address.street,
				:address2 => self.billing_address.street2,
				:city => self.billing_address.city,
				:state => self.billing_address.state,
				:zip => self.billing_address.zip,
				:country => self.billing_address.country,
				:phone => self.billing_address.phone
			}
		}
	end


#---------------------------------------------------------------
# Validation for credit card, shipping address and billing address
#---------------------------------------------------------------
	def validate_card
		if paypal_express_token.blank? && !credit_card.valid?
			credit_card.errors.full_messages.each do |message|
				errors.add_to_base message
			end
		end
	end
	
	def validate_billing_address
		if paypal_express_token.blank? && self.billing_address.invalid?
			billing_address.errors.full_messages.each do |message|
				errors.add_to_base message
			end
		end
	end
	
	def validate_shipping_address
		if paypal_express_token.blank? && self.shipping_address.invalid?
			shipping_address.errors.full_messages.each do |message|
				errors.add_to_base message
			end
		end
	end
	
	def validate_unique_order
		# of course, only do this for digital orders.  Folks can buy all the t-shirts they want
		unless self.sku.merch_sku?
			if self.user.orders.present? && self.user.orders.successful.present?
				if existing_order = self.user.orders.successful.find_by_sku_id( self.sku_id )
					txn_number = existing_order.order_transaction.reference
					message = "You have already purchased this item.  The transaction number your previous order was <b>#{txn_number}</b>.  <br>You can access your files by logging in or registering an account using the email #{existing_order.user.email}.<br> If you are having problems with this order, or if you would like to purchase this item again, please <a href='contacts/new'>contact support</a>." 
					errors.add_to_base message
				end
			end
		end
	end

	def validate_available_quantity
		if self.sku.contains_merch?
			if self.sku.remaining_quantity < self.sku_quantity
				message = "Sorry, we only have #{self.sku.remaining_quantity} left for this item.  Please change the quantity."
				errors.add_to_base message
			end
		end
	end
	




end
