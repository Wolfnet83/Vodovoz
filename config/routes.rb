Vodovoz::Application.routes.draw do
  devise_for :users

  get "missed_calls/index"

  get "clients/index"

  get "clients/create"

  delete "clients/delete"

  get "clients/update"

  get "reports/index"

  get "reports/incoming_calls"

  post "reports/incoming_calls"

  get "reports/main_report"

  post "reports/main_report"

  get "reports/operator"

  post "reports/operator"

  get "reports/unanswered_calls"
  post "reports/unanswered_calls"

  get "reports/missed_calls"
  post "reports/missed_calls"

  get   "calls/index"

  post "calls/index"

  post "calls/page_select"

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
    get "calls/search_by_request"

    resources :clients
    resources :reports
    resources :calls
    resources :search_requests


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
   root :to => 'calls#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  #devise_for :users, controllers: { registrations: "registrations" }
end
