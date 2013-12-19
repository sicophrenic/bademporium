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
    # CRUD-type actions
    post 'create', :action => 'create_game'
    get 'new', :action => 'new_game'
    get 'destroy/:id', :action => 'destroy_game', :as => 'destroy'

    get 'join/:id', :action => 'join_game', :as => 'join' # TODO - make this a post?
    get 'find', :action => 'find_game'

    # pre/post-game actions
    post 'deal_me_in/:id/player/:player_id', :action => 'ready_up', :as => 'ready_up'
    post 'game_start/:id', :action => 'game_start', :as => 'game_start'
    post 'redeal/:id', :action => 'redeal', :as => 'redeal'

    # game actions
    post ':id/hit/:player_id', :action => 'hit', :as => 'hit'
    post ':id/stand/:player_id', :action => 'stand', :as => 'stand'
    post ':id/split/:player_id', :action => 'split', :as => 'split'
    post ':id/double/:player_id', :action => 'double', :as => 'double'
  end

  scope :api, :controller => 'api' do
    # post 'blackjack_hit/:blackjack_game_id/player/:player_id/hand/:hand_id', :action => 'blackjack_hit', :as => 'blackjack_hit'
    # post 'blackjack_stand/:blackjack_game_id/player/:player_id/hand/:hand_id', :action => 'blackjack_stand', :as => 'blackjack_stand'
    # post 'blackjack_double/:blackjack_game_id/player/:player_id/hand/:hand_id', :action => 'blackjack_double', :as => 'blackjack_double'
    # post 'blackjack_split/:blackjack_game_id/player/:player_id/hand/:hand_id', :action => 'blackjack_split', :as => 'blackjack_split'
  end

  scope :admin, :controller => 'admin' do
    get '/', :action => 'index', :as => 'admin'
    get 'deploy_services'
  end

  scope :deploy_service, :controller => 'deploy_services' do
    post 'enable_for_everyone/:id', :action => 'enable_for_everyone', :as => 'enable_deploy_service_for_everyone'
    post 'enable_for_beta/:id', :action => 'enable_for_beta', :as => 'enable_deploy_service_for_beta'
    post 'disable/:id', :action => 'disable', :as => 'disable_deploy_service'
  end
end