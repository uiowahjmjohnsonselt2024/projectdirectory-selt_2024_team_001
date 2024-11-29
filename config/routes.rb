Rails.application.routes.draw do
  # Root route pointing to the login menu
  root 'sessions#login_menu'

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

end
