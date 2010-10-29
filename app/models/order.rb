# == Schema Information
# Schema version: 20101026212141
#
# Table name: orders
#
#  id                      :integer(4)      not null, primary key
#  user_id                 :integer(4)
#  ordered_id              :integer(4)
#  ordered_type            :integer(4)
#  email                   :string(255)
#  ip                      :string(255)
#  price                   :integer(4)
#  status                  :string(255)
#  paypal_express_token    :string(255)
#  paypal_express_payer_id :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class Order < ActiveRecord::Base
	belongs_to :user
	has_many :order_transactions,
		:dependent => :destroy
	
	belongs_to :ordered, :polymorphic  => :true
	
	attr_accessor :payment_type, :card_number, :card_cvv, :fname, :lname, :card_exp_month, :card_exp_year, :card_type, :periodicity
	attr_accessor :address1, :address2, :city, :geo_state, :zip, :country, :phone
	
# TODO - need to redo validation for Rails 3...	
#	validate_on_create :validate_card

#-------------------------------------------------------------------------
# Method calling Paypal Gateways for purchases (both regular and express)
#-------------------------------------------------------------------------
	# Call Paypal and get response object
	def purchase
		if price > 0
			response = process_purchase
			order_transactions.create!(	:action => "purchase", 
										:price => price, 
										:success => response.success?, 
										:reference => response.authorization,
										:message => response.message,
										:params => response.params,
										:test => response.test? )
			response.success?
		elsif price == 0
			order_transactions.create!( :action => "purchase",
										:price => price, 
										:success => true, 
										:reference => 'BackMyBook coupon purchase',
										:message => 'zero price purchase'
										)
			return true			
		else
			false
		end
	end
	


#------------------------------------------------------------------
# Methods calling Paypal Gateways for subscriptions
#------------------------------------------------------------------
	def subscription
		if price > 0
			response = GATEWAY.recurring(price, credit_card, options_recurring)
			order_transactions.create!(	:action => "subscription", 
										:price => price, 
										:success => response.success?, 
										:reference => response.authorization,
										:message => response.message,
										:params => response.params,
										:test => response.test? )

			response.success?
		else
			return false
		end
	end

	def inquire_subscription(profile_id)
		response = GATEWAY.recurring_inquiry(profile_id)
		# logger.debug("DEBUG INQUIRE SUBSCRIPTION #{response.inspect}")
		return response
	end
	
	def suspend_subscription(profile_id)
		response = GATEWAY.suspend_recurring(profile_id)
		#logger.debug("DEBUG SUSPEND SUBSCRIPTION #{response.inspect}")
		response.success?
	end
	
	def cancel_subscription(profile_id)
		response = GATEWAY.cancel_recurring(profile_id)
		logger.debug("DEBUG CANCEL SUBSCRIPTION #{response.inspect}")
		response.success?
	end

	# Return status for an order, based on Paypal's response to the order in the order_transaction 
	def successful?
		answer = false
		for ot in self.order_transactions
			answer = true if ot.success
		end
		return answer		
	end


  private

	# Set up credit card object for gateway call
	def credit_card
		@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
			:type => card_type,
			:number => card_number,
			:verification_value => card_cvv,
			:month => card_exp_month,
			:year => card_exp_year,
			:first_name => fname,
			:last_name => lname
			)
	end

	# Use regular gateway or Paypal express gateway based on token
	def process_purchase
		if paypal_express_token.blank?
			GATEWAY.purchase(price, credit_card, options)
		else
			EXPRESS_GATEWAY.purchase(price, options_express)
		end
	end

#------------------------------------------------------------------------
# Set up options for different types of payment calls to Paypal Gateways
#------------------------------------------------------------------------
	#Set up options hash for regular Paypal gateway call 
	def options
		@options = {
			:ip => ip,
			:billing_address => {
				:name => fname + " " + lname,
				:address1 => address1,
				:address2 => address2,
				:city => city,
				:state => geo_state,
				:zip => zip,
				:country => country,
				:phone => phone
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
		if periodicity == 'daily'
			period = :daily
		elsif periodicity == 'weekly'
			period  = :weekly
		elsif periodicity == 'monthly'
			period = :monthly
		elsif periodicity == 'yearly'
			period = :yearly
		elsif periodicity == 'quarterly'
			period = :quarterly
		else
			period = :monthly
		end
		
		@options = {
			:ip => ip_address,
			:periodicity => period,
			:email => email,
			:comment => description,
			:starting_at => Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
			:billing_address => {
				:name => fname + " " + lname,
				:address1 => address1,
				:address2 => address2,
				:city => city,
				:state => geo_state,
				:zip => zip,
				:country => country,
				:phone => phone
			}
		}
	end


#---------------------------------------------------------------
# Validation for credit card
#---------------------------------------------------------------
	def validate_card
		if paypal_express_token.blank? && !credit_card.valid?
			credit_card.errors.full_messages.each do |message|
				errors.add_to_base message
			end
		end
	end
	

end
