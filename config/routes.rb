Backmybook::Application.routes.draw do

	# Highest-priority root is non-app domain and send root to author controller
	# constraints( Domain ) is defined in lib/domain.rb and simply matches request domain against 
	# an array of known domains (defined in config/initializers/app.rb). 
	# Anything that doesn't match is assumed to be an author
	constraints( Domain ) do
		match '/' => 'authors#show'
	end
	
	# Next is subdomain and send root to author controller
	# constraints( Subdomain ) is defined in lib/subdomain.rb and simply matches request domain against 
	# an array of known subdomains (defined in config/initializers/app.rb).  
	# Anything that doesn't match is assumed to be an author
	constraints( Subdomain ) do
		match '/' => 'authors#show'
	end
	
	# finally map application root on primary domain without subdomain to site index
	root :to => "sites#index"
	
	# app resource routes, hopefully maintained in alpha order
	resources :articles do
		resources :comments
	end
	
	resources :assets do
		get 'deliver', :on => :member
	end
		
	resources :authors do
		resources :articles
		get 'bio', :on => :member
		get 'help', :on => :member
		get 'platform_builder', :on => :collection
		get 'edit_profile', :on => :member
		get 'contact', :on => :member
		
		resources :blog do
			get 'admin', :on => :collection
		end
		resources :books do
			get 'admin', :on => :collection
			
			get 'preview', :on => :member
			
			# all these routes just to edit STI resource on books
			resources :etext, :controller => :assets
			resources :pdf, :controller => :assets
			resources :audio, :controller => :assets
			resources :assets do
				get 'download', :on => :member
			end
			resources :reviews
		end
		resources :coupons do
			get 'admin', :on => :collection
		end
		resources :email_campaigns do
			resources :email_messages do
				get 'admin', :on => :collection
				get 'send_to_self', :on => :member
				get 'send_to_subscriber', :on => :member
				get 'admin_get_merch_orders', :on  => :collection
				get 'admin_edit_shipping_email', :on => :collection
				get 'admin_send_shipping_email', :on => :collection
				get 'admin_list', :on => :collection
				post 'deliver_test_email', :on => :collection
			end
		end
		
		resources :email_templates do
			get 'admin', :on => :collection
		end
		
		resources :events do
			get 'admin', :on => :collection
		end
		resources :forums do
			get 'admin', :on => :collection
			resources :topics do
				resources :posts
			end
		end
		
		resources :links do
			get 'admin', :on => :collection
		end
		
		post 'newsletter_signup', :on => :member, :as => 'newsletter_signup'

		resources :orders, :constraints => { :protocol => Rails.env.production? ? "https" : "http"}
			
		resources :podcasts do
			get 'admin', :on => :collection
			resources :episodes do
				get 'download', :on => :member
				resources :comments
			end
		end
		
		resources :merches do
			resources :reviews
		end
		
		resources :skus do
			resources :merches
			resources :assets
			get 'sort', :on => :collection
			post 'add_item', :on => :member
			post 'remove_item', :on => :member
		end
		
		resources :store do
			get 'admin', :on => :collection
			get 'faq', :on => :collection
			get 'promo', :on => :collection
		end
		
		resources :sites do
			get 'admin', :on => :collection
		end
		
		resources :themes do
			post 'activate', :on => :collection
		end
		resources :upload_email_lists
		
	end
	
	# For direct - url and subdomain access....
	resources :blog do # for the site blog
		get 'admin', :on => :collection
	end
	
	resources :books
	
	resources :comments do
		get 'mark_as_spam', :on => :member
	end
	
	resources :contacts
	
	resources :contracts do
		post :agree, :on => :member
	end
	
	resources :crashes
	
	resources :email_messages do
		get 'admin', :on => :collection
	end
	
	resources :email_templates do
		get 'admin', :on => :collection
	end
	
	resources :events do
		get 'admin', :on => :collection
	end
	
	resources :forums
	resources :store
	resources :podcasts do
		resources :episodes do
			get 'download', :on => :member
			resources :comments
		end
	end
	
	resources :links do
		get 'admin', :on => :collection
	end
		
	resources :forums do
		resources :topics do
			resources :posts
		end
	end

	resources :orders , :constraints => { :protocol => Rails.env.production? ? "https" : "http"} do
		get 'go_paypal', :on => :collection
		get 'ret_paypal', :on => :collection
		get 'admin', :on => :collection
		get 'inspect', :on => :member
		get 'admin', :on => :collection
		get 'refund', :on => :member
		post 'confirm_refund', :on => :member
	end
	
	resources :order_transactions
	
	resources :podcasts do # for the site podcast
		resources :episodes do
			get 'download', :on => :member
			resources :comments
		end
	end
	
	resources :refunds
	
	resources :sessions do
		collection do
			get 'pending'
			get 'register'
			post 'go_facebook'
			post 'go_site_facebook'
			get 'ret_facebook'
			get 'ret_site_facebook'
			post 'go_twitter'
			post 'go_site_twitter'
			get 'ret_twitter'
			get 'ret_site_twitter'
		end
	end
	
	# really just so the site can create these resources with the scoped form_for [@admin, Resource.new]
	resources :site do
		resources :articles
		resources :events
		resources :links 
	end
	
	resources :site_admin do
		get :blog, :on => :collection
		get :new_blog, :on => :collection
		get :edit_blog, :on => :collection
		get :users, :on => :collection
		get :comments, :on => :collection
	end
	
	resources :static_pages do
		get 'admin', :on => :collection
	end

	resources :subscribings do
		member do
			get 'cancel'
		end
	end
	
	resources :themes do
		get 'admin', :on => :collection
	end
	
	resources :upload_email_lists do
		get 'download', :on => :collection
	end
	
	resources  :users do
		resources :recommends
		collection do
			get 'admin'
			post 'update_password'
		end
		member do
			post 'update_avatar'
		end
		get 'resend', :on => :member
	end
	
	# named routes
	match '/activate' => 'users#activate', :as => 'activate'
	
	match '/author/signup' => 'authors#signup', :as => :author_signup

	match '/reports/(:action)' => 'reports', :as => :report
	
	# Admin for authors
	match '/admin/' => 'admin#index', :as => :admin_index
	
	
	# Site Admin -- blog/podcasts, maybe customer support
	match '/site-admin/' => 'admin#site'
	match '/site-admin/blog' => 'site_admin#blog', :as => :site_admin_blog
	match '/site-admin' => 'site#admin', :as => 'site_admin'
	
	match '/author:author_id/search/(:term)' => 'authors#search', :as => 'search_author'
	
	match '/site/newsletter_signup' => 'sites#newsletter_signup', :as => 'site_newsletter_signup'
		
	match '/blog/archive/(:year/(:month))', :to => 'blog#index'
	match '/authors/:author_id/blog/archive/(:year/(:month))', :to => 'blog#index'
	
	match '/forgot' => 'users#forgot_password', :as => 'forgot'
	match '/logout' => 'sessions#destroy', :as => 'logout'
	match '/login' => 'sessions#new', :as => 'login'
	match '/register' => 'sessions#register', :as => 'register'
	match '/reset' => 'users#reset_password', :as => 'reset'
	match '/logo/:code', :to => 'email_deliveries#process_open', :as => 'logo' 

		
	match '/redeem_code/:code', :to => 'coupons#redeem_code', :as => 'redeem_code'
	match 'coupons/validate/:sku_id/:code', :to => 'coupons#validate', :as => 'validate_coupon'
	
	#for sku sorting ajax
	match '/skus/update_sort', :to => 'skus#update_sort'
	
	match "/:permalink", :to => 'static_pages#show'
		
	match "/unsubscribe/:code", :to => "email_subscribings#unsubscribe"
		
		
end
