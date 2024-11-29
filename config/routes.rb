Rails.application.routes.draw do
  # Root route pointing to the login menu
  root 'videos#sponsor_intro'

  # Routes for user sign-up, account management, etc.
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :achievements, only: [:index]
  end

  # Routes for payment processing system
  resources :charges, only: [:create]

  # Custom route for user sign-up
  get 'signup', to: 'users#new', as: :signup

  # Session management routes
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout

  # Session-related screens

  # Routes for screens after login
  get 'welcome_screen', to: 'sessions#welcome_screen', as: 'welcome_screen'
  get 'main_game_screen', to: 'sessions#main_game_screen', as: 'main_game_screen'
  get 'welcome_settings', to: 'sessions#welcome_settings', as: 'welcome_settings'
  # routes.rb
  resources :servers, only: [:index, :create, :show, :destroy] do
    member do
      post :add_user
      get :game_view
      get :grid
    end
  end


  post '/add_user_custom', to: 'servers#add_user_custom', as: :add_user_custom

  get 'user_profile', to: 'sessions#user_profile', as: 'user_profile'


  get 'shard_purchase', to: 'sessions#shard_purchase', as: 'shard_purchase'
  #get :stripe_payment, to: 'application#stripe_payment'

  # Route for the sponsor intro video (view, not the file itself)
  get 'videos/sponsor_intro', to: 'videos#sponsor_intro', as: 'sponsor_intro'

  # Route for the game intro video (view, not the file itself)
  get 'videos/game_intro', to: 'videos#game_intro', as: 'game_intro'

  # Route to render the login page after videos are watched
  get 'videos/end_intro', to: 'videos#end_intro', as: 'end_intro'
  get 'storefront/select_action', to: 'storefront#select_action'

  get 'storefront/store_menu', to: 'storefront#store_menu'
  get 'storefront/ships', to: 'storefront#ships'
  get 'storefront/modules', to: 'storefront#modules'
  get 'storefront/crew', to: 'storefront#crew'
  get 'storefront/consumables', to: 'storefront#consumables'

  get 'storefront/trade', to: 'storefront#trade'

  post 'storefront/update_gold', to: 'storefront#update_gold'


end
