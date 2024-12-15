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

  get 'sessions/login_menu', to: 'sessions#login_menu', as: :login_menu

  # Session-related screens

  # Routes for screens after login
  get 'welcome_screen', to: 'sessions#welcome_screen', as: 'welcome_screen'
  get 'main_game_screen', to: 'sessions#main_game_screen', as: 'main_game_screen'
  get 'welcome_settings', to: 'sessions#welcome_settings', as: 'welcome_settings'
  # routes.rb
  resources :servers, only: [:index, :create, :show, :destroy] do
    resources :messages, only: [:create]
    resources :players, only: [] do
      member do
        patch :update_position
        patch :collect_gold
        get :generate_story
      end
    end

    member do
      post :add_user
      get :game_view
      get :grid
      post :send_chat_message
    end
  end


  post '/add_user_custom', to: 'servers#add_user_custom', as: :add_user_custom

  get 'user_profile', to: 'sessions#user_profile', as: 'user_profile'
  # config/routes.rb
  #For updating the profile picture
  post '/update_profile_picture', to: 'users#update_profile_picture'
  get 'shard_purchase', to: 'sessions#shard_purchase', as: 'shard_purchase'

  # A route that is used to go to the start screen
  get "videos/start_screen", to: 'videos#start_screen', as: 'start_screen'

  # Route for the sponsor intro video (view, not the file itself)
  get 'videos/sponsor_intro', to: 'videos#sponsor_intro', as: 'sponsor_intro'

  # Route for the game intro video (view, not the file itself)
  get 'videos/game_intro', to: 'videos#game_intro', as: 'game_intro'

  # Route to render the login page after videos are watched
  get 'videos/end_intro', to: 'videos#end_intro', as: 'end_intro'

  resources :storefront, only: [:index] do
    collection do
      post 'purchase_item'
      get 'ships'
      get 'modules'
      get 'crew'
      get 'consumables'
      get 'store_menu'
      post 'update_gold'
    end
  end

  resources :players, only: [] do
    member do
      get 'inventory' # Add route for the inventory view
    end
    resources :player_items, only: [:index, :create, :update], shallow: true
  end



  patch 'toggle_theme', to: 'sessions#toggle_theme', as: :toggle_theme

  mount ActionCable.server => '/cable'
  post 'convert', to: 'conversions#convert'


  # Route for chat
  post 'chat', to: 'chats#create'



  get 'convert_to_usd', to: 'conversions#convert_to_usd'


  post 'update_session_profile_picture', to: 'sessions#update_session_profile_picture'

  post 'update_session_profile_picture', to: 'sessions#update_session_profile_picture'



end
