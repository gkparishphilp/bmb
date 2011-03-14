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
		resources :blog
		resources :books do
			get 'mockup', :on => :collection
			post 'confirm', :on => :collection
			# all these routes just to edit STI resource on books
			resources :ebook, :controller => :assets
			resources :pdf, :controller => :assets
			resources :audio_book, :controller => :assets
			resources :assets do
				get 'download', :on => :member
			end
			resources :reviews
		end
		resources :email_campaigns do
			resources :email_messages 
		end
		resources :events
		resources :forums do
			resources :topics do
				resources :posts
			end
		end
		resources :orders, :constraints => { :protocol => Rails.env.production? ? "https" : "http"}
			
		resources :podcasts do
			resources :episodes do
				get 'download', :on => :member
				resources :comments
			end
		end
		resources :merches do
			resources :reviews
		end
		resources :skus do
			put 'add_item', :on => :member
		end
		resources :store do
			get 'admin', :on => :collection
		end
		
		resources :sites
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
	
	resources :contacts
	
	resources :crashes
	
	resources :email_messages do
		get 'admin', :on => :collection
		get 'admin_list', :on => :collection
		get 'send_to_self', :on => :collection
		get 'send_to_subscriber', :on => :collection
		get 'admin_get_merch_orders', :on  => :collection
		get 'admin_edit_shipping_email', :on => :collection
		get 'admin_send_shipping_email', :on => :collection
		post 'send_test_email', :on => :collection
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
	
	resources :merches
		
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
	end
	
	resources :order_transactions
	
	resources :podcasts do # for the site podcast
		resources :episodes do
			get 'download', :on => :member
			resources :comments
		end
	end
	
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
	
	match '/admin/' => 'admin#index', :as => :admin_index

	# todo Clean up routes for reporting when I've figured out how to post and get the same resourced route
	match '/reports/sales' => 'reports#sales', :as => :reports_sales
	match '/reports/redemptions' => 'reports#redemptions', :as => :reports_redemptions
	match '/reports/emails' => 'reports#emails', :as => :reports_emails
		
	# Site Admin -- blog/podcasts, maybe customer support
	match '/site-admin/' => 'admin#index', :as => :site_admin_index  # for now, send site-admin root to old admin interface
	match '/site-admin/blog' => 'site_admin#blog', :as => :site_admin_blog
		
	match '/blog/archive/(:year/(:month))', :to => 'blog#index'
	match '/authors/:author_id/blog/archive/(:year/(:month))', :to => 'blog#index'
	
	match '/site-admin' => 'site#admin', :as => 'site_admin'
	match '/forgot' => 'users#forgot_password', :as => 'forgot'
	match '/logout' => 'sessions#destroy', :as => 'logout'
	match '/login' => 'sessions#new', :as => 'login'
	match '/register' => 'sessions#register', :as => 'register'
	match '/reset' => 'users#reset_password', :as => 'reset'
	match '/logo/:code', :to => 'email_deliveries#process_open', :as => 'logo' 
	
	
	match '/redeem_code/:code', :to => 'coupons#redeem_code', :as => 'redeem_code'
	match 'coupons/validate/:sku_id/:code', :to => 'coupons#validate', :as => 'validate_coupon'
	
	
	match "/:permalink", :to => 'static_pages#show'
		
	match "/unsubscribe/:code", :to => "email_subscribings#unsubscribe"
		
		

# The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
