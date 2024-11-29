Rails.application.routes.draw do
  # Root route pointing to the login menu
  root 'sessions#login_menu'

  # Routes for user sign-up, account management, etc.
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]

  # Custom route for user sign-up
  get 'signup', to: 'users#new', as: :signup

  # Session management routes (assuming you want login/logout functionality)
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout

  get 'welcome_screen', to: 'sessions#welcome_screen', as: 'welcome_screen'
  get 'main_game_screen', to: 'sessions#main_game_screen', as: 'main_game_screen'
  get 'welcome_settings', to: 'sessions#welcome_settings', as: 'welcome_settings'

  get 'storefront/select_action', to: 'storefront#select_action'

  get 'storefront/store_menu', to: 'storefront#store_menu'
  get 'storefront/ships', to: 'storefront#ships'
  get 'storefront/modules', to: 'storefront#modules'
  get 'storefront/crew', to: 'storefront#crew'
  get 'storefront/consumables', to: 'storefront#consumables'

  get 'storefront/trade', to: 'storefront#trade'

  post 'storefront/update_gold', to: 'storefront#update_gold'


end
