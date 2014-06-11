Shnack::Application.routes.draw do
  resources :orders do 
    resources :charges
    post '/:action'
  end

    get '/api/:action', :controller => 'api'
    post '/api/:action', :controller => 'api'

     get '/charges/:action', :controller => 'charges'
    post '/charges/:action', :controller => 'charges'


  devise_for :users
  # The priority is based upon order of creation:
  # first created -> highest priority.

  root to: "application#select_stadium"
  match 'user_root' => 'application#select_stadium', as: :user_root


  resources :restaurants do
    member do
      get 'new_registration_code'
      get 'bank_account'
      post 'save_bank_account'
    end
  end
  

  
  resources :stadia, :path => "stadiums" do
    resources :vendors do
      member do
        get 'new_registration_code'
      end
    end
    get '/:controller/:action'
    post '/:controller/:action'
  end

  resource :user, :path => "u"

  

  # get '/u/edit', :controller => "users", :action => "edit"
  get '/menu/:action', :controller => 'menu'
  post '/menu/:action', :controller => 'menu'
 
  get '/shnack/:action', :controller => 'shnack'
  post '/shnack/:action', :controller => 'shnack'
	get '/:action/:object_id', :controller => 'application'




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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
