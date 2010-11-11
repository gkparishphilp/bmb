Backmybook::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.after_initialize do
	ActiveMerchant::Billing::Base.mode = :test
	paypal_options = {
		:login => 'seller_1269634095_biz_api1.sky360corp.com',
		:password => '1269634102',
		:signature    => 'AuXPSjM3yDZbAYTXCoh4IdooQpR1Aw-6vQhoTPFyzZZ9Am7v6q6l1LiD'
	}
	
	::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
	::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
	
	require 'amazon/ecs'
	Amazon::Ecs.configure do |options|
        options[:aWS_access_key_id] = AMAZON_ID
        options[:aWS_secret_key] = AMAZON_SECRET
    end

  end

end

# TODO - update these to the BmB FB App Keys
FB_APP_ID = "260902867245"
FB_API_KEY = "5f7b0c83181abea7e88bd7b9e42de985"
FB_APP_SECRET = "b2dc621635361de10eaab4e9f90624a7"
