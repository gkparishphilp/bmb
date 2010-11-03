require 'rubygems'
require 'active_merchant'

# Use the gateway's test server
# BEGIN mode
ActiveMerchant::Billing::Base.mode = :test
# END mode

# Construct the instance of the Paypal payment gateway using the
# credentials.
# BEGIN construct
gateway = ActiveMerchant::Billing::PaypalGateway.new({
  :login => 'seller_1269634095_biz_api1.sky360corp.com',
  :password => '1269634102',
  :signature    => 'AuXPSjM3yDZbAYTXCoh4IdooQpR1Aw-6vQhoTPFyzZZ9Am7v6q6l1LiD',
})
# END construct

# Next, construct a CreditCard object that will be charged during the
# transaction
# BEGIN credit_card
credit_card = ActiveMerchant::Billing::CreditCard.new({
  :first_name => 'Some',
  :last_name  => 'Buyer',
  :number     => '4913645663303519 ',
  :month      => '3',
  :year       => '2015',
  :verification_value => '999',
})


options = {
    :ip => '192.168.2.1',
    :billing_address => {
      :name     => 'Tay Nguyen',
      :address1 => '1234 Shady Brook Lane',
      :address2 => 'Apartment 1',
      :city     => 'San Diego',
      :state    => 'CA',
      :country  => 'US',
      :zip      => '92129',
      :phone    => '555-555-5555'
    }
}
# END credit_card

# BEGIN purchase

if credit_card.valid?
  response = gateway.purchase(100, credit_card, options)

  print "(TEST) " if response.test?

  if response.success?
    puts "The transaction was successful! The authorization is #{response.authorization}"
	puts "The response is #{response.inspect}"

  else
    puts "The transaction was unsuccessful because #{response.message}"
  end
else
  puts "The credit card is invalid. #{credit_card.errors.full_messages.join('. ')}"
end
# END purchase

# BEGIN purchase_output
# => (TEST) The transaction was successful! The authorization is 3459652
# END purchase_output