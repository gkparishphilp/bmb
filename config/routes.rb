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
		resources :links
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
		resources :store
		resources :sites
		resources :themes do
			post 'activate', :on => :collection
		end
		resources :upload_email_lists
		
	end
	
	# For direct - url and subdomain access....
	resources :blog  # for the site blog
	resources :books
	resources :events
	resources :forums
	resources :store
	resources :podcasts do
		resources :episodes do
			get 'download', :on => :member
			resources :comments
		end
	end
	resources :links
	resources :merches
	
	resources :contacts
	
	resources :crashes
		
	resources :forums do
		resources :topics do
			resources :posts
		end
	end

	resources :orders , :constraints => { :protocol => Rails.env.production? ? "https" : "http"} do
		get 'paypal_express', :on => :new
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
	
	resources :site do
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
	
	resources :themes
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
	
	match '/admin/acount' => 'admin#account', :as  => :admin_account
	match '/admin/books' => 'admin#books', :as => :admin_books
	match '/admin/blog' => 'admin#blog', :as => :admin_blog
	match '/admin/themes' => 'admin#themes', :as => :admin_themes
	match '/admin/domains' => 'admin#domains', :as => :admin_domains
	match '/admin/email' => 'admin#email', :as => :admin_email
	match '/admin/links' => 'admin#links', :as => :admin_links
	match '/admin/newsletter' => 'admin#newsletter', :as => :admin_newsletter
	match '/admin/' => 'admin#index', :as => :admin_index
	match '/admin/podcast' => 'admin#podcast', :as => :admin_podcast
	match '/admin/reports' => 'admin#reports', :as => :admin_reports
	match '/admin/forums' => 'admin#forums', :as => :admin_forums
	match '/admin/orders'  => 'admin#orders', :as => :admin_orders
	match '/admin/profile' => 'admin#profile', :as => :admin_profile
	match '/admin/events' => 'admin#events', :as => :admin_events
	match '/admin/social_media' => 'admin#social_media', :as => :admin_social_media
	match '/admin/store' => 'admin#store', :as => :admin_store
	match '/admin/send_social_message' => 'admin#send_social_message', :as => :admin_send_social_message
	
	match '/blog/archive/(:year/(:month))', :to => 'blog#index'
	match '/authors/:author_id/blog/archive/(:year/(:month))', :to => 'blog#index'
	
	match '/site-admin' => 'site#admin', :as => 'site_admin'
	match '/forgot' => 'users#forgot_password', :as => 'forgot'
	match '/logout' => 'sessions#destroy', :as => 'logout'
	match '/login' => 'sessions#new', :as => 'login'
	match '/register' => 'sessions#register', :as => 'register'
	match '/reset' => 'users#reset_password', :as => 'reset'
	
	
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
