#-*- coding: utf-8 -*-#
Bademporium::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get "pages/home"

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  devise_for :users

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  namespace :blackjack do
    get 'new', :action => 'new_game'
    post 'create', :action => 'create_game'
    get 'join/:id', :action => 'join_game', :as => 'join'
    get 'find', :action => 'find_game'
    get 'destroy/:id', :action => 'destroy_game', :as => 'destroy'
  end

  scope :api, :controller => 'api' do
    post 'blackjack_hit'
    post 'blackjack_stand'
    post 'blackjack_double'
    post 'blackjack_split'
  end
end