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
  delete 'logout', to: 'sessions#destroy'

  get '/welcome', to: 'menus#welcome', as: 'welcome'
  get '/start_menu', to: 'menus#start_menu', as: 'start_menu'

end
