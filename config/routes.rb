Backmybook::Application.routes.draw do

	root :to => "site#index"

	resources :authors do
		member do
			get :admin
		end
		
		resources :upload_email_lists
		resources :email_campaigns do
			resources :email_messages
		end
	end
	
	resources :articles do
		resources :comments
	end

	resources :blog do
		get 'admin', :on => :collection
	end
	
	resources :contacts
	
	resources :coupons do
		collection do
			post :giveaway_redeem
		end
	end
	
	resources :crashes
		
	resources :forums do
		get 'admin', :on => :collection
		resources :topics do
			resources :posts
		end
	end
	
	resources :merches

	resources :order_transactions

	resources :orders
	
	resources :podcasts do
		get 'admin', :on => :collection
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
		collection do
			get 'admin'
		end
		resources :links do
			get 'admin', :on => :collection
		end
	end
	
	resources :static_pages do
		get 'admin', :on => :collection
	end
	
	resources :upload_email_lists
	
	resources  :users do
		collection do
			get 'admin'
			post 'update_password'
		end
		get 'resend', :on => :member
	end
	
	
	match '/activate' => 'users#activate', :as => 'activate'
	match '/admin' => 'site#admin', :as => 'admin'
	match '/forgot' => 'users#forgot_password', :as => 'forgot'
	match '/logout' => 'sessions#destroy', :as => 'logout'
	match '/login' => 'sessions#new', :as => 'login'
	match '/register' => 'sessions#register', :as => 'register'
	match '/reset' => 'users#reset_password', :as => 'reset'
	
	match '/blog/archive/(:year/(:month))', :to => 'blog#index'
	
	match "/:permalink", :to => 'static_pages#show'
	
	match "/redeem/:code", :to => "coupons#giveaway_redeem"
	
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
