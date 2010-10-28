class Order < ActiveRecord::Base
	belongs_to :user
	has_many :order_transactions,
		:dependent => :destroy
	
	belongs_to :orderable, :polymorphic  => :true
	
	attr_accessor :payment_type, :card_number, :card_cvv, :fname, :lname, :card_exp_month, :card_exp_year, :card_type, :periodicity
	attr_accessor :address1, :address2, :city, :geo_state, :zip, :country, :phone
	
	validate_on_create :validate_card

	def validate_card
		if paypal_express_token.blank? && !credit_card.valid?
			credit_card.errors.full_messages.each do |message|
				errors.add_to_base message
			end
		end
	end
	
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
end
