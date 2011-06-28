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

express_gateway = ActiveMerchant::Billing::PaypalExpressGateway.new({
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
	puts "Transaction ID is "
	puts "#{response.params["transaction_id"]}"

  else
    puts "The transaction was unsuccessful because #{response.message}"
  end
else
  puts "The credit card is invalid. #{credit_card.errors.full_messages.join('. ')}"
end
# END purchase

# BEGIN refund
refund_response = gateway.credit(50, response.params["transaction_id"])

if refund_response.success?
	puts "Refund processed! The authorization is #{refund_response.authorization}"
else
	puts "Refund failed!"
end
puts "Refund response is #{refund_response.inspect}"
	

# BEGIN transfer to test account
transfer_response = gateway.transfer(999, 'buyer_1269634012_per@sky360corp.com', :note => 'transfer test of $9.99')

if transfer_response.success?
	puts "Transfer succeeded! Authorization is #{transfer_response.authorization}"
else
	puts "Transfer failed!"
end
puts "Transfer response is #{transfer_response.inspect}"	

=begin
Here's the return from a paypal express purchase
Get it by doing a transaction and then querying for the details in rails console: data= EXPRESS_GATEWAY.details_for('EC-5597694722013783L')
#<ActiveMerchant::Billing::PaypalExpressResponse:0x000001053c2d90 @params={"timestamp"=>"2011-06-28T17:30:51Z", "ack"=>"Success", "correlation_id"=>"9d6d75ab3a098", "version"=>"59.0", "build"=>"1936884", "token"=>"EC-5597694722013783L", "payer"=>"buyer_1269634012_per@sky360corp.com", "payer_id"=>"7T28RWEPAA9CW", "payer_status"=>"verified", "salutation"=>nil, "first_name"=>"Test", "middle_name"=>nil, "last_name"=>"User", "suffix"=>nil, "payer_country"=>"US", "payer_business"=>nil, "name"=>"Test User", "street1"=>"1 Main St", "street2"=>nil, "city_name"=>"San Jose", "state_or_province"=>"CA", "country"=>"US", "country_name"=>"United States", "phone"=>nil, "postal_code"=>"95131", "address_owner"=>"PayPal", "address_status"=>"Confirmed", "order_total"=>"2.99", "order_total_currency_id"=>"USD", "shipping_total"=>"0.00", "shipping_total_currency_id"=>"USD", "handling_total"=>"0.00", "handling_total_currency_id"=>"USD", "tax_total"=>"0.00", "tax_total_currency_id"=>"USD", "address_id"=>nil, "external_address_id"=>nil, "insurance_total"=>"0.00", "insurance_total_currency_id"=>"USD", "shipping_discount"=>"0.00", "shipping_discount_currency_id"=>"USD"}, @message="Success", @success=true, @test=true, @authorization=nil, @fraud_review=false, @avs_result={"code"=>nil, "message"=>nil, "street_match"=>nil, "postal_match"=>nil}, @cvv_result={"code"=>nil, "message"=>nil}> 
=end
