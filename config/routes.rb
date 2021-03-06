TwitterClone::Application.routes.draw do
  get "users/index"
  get "users/followers/:id" => "users#followers", :as => "followers"
  get "users/following/:id" => "users#following", :as => "following"

  post "followers/create/:id" => "followers#create", :as => "followers_create"

  delete "followers/destroy/:id" => "followers#destroy", :as => "followers_destroy"

  

  get "users/user_tweets/:id" => "users#user_tweets", :as => "user_tweets"

  post "tweets/create" => "tweets#create"

  get "users/show/:id" => "users#show"

  devise_for :users

  resources :tweets

  match "/:user_name" => "users#show", as: "show_user"


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

  devise_scope :user do
    authenticated :user do
      root :to => 'tweets#index'
    end
    unauthenticated :user do
      root :to => 'devise/sessions#new'
    end
  end

  match '*path' => redirect('/')

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
