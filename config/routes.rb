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

  #Template
  #post '/movies/add_tmdb', to: 'movies#add_tmdb', as: 'add_tmdb_movies'
  #
  post '/sessions/login_menu', to: 'sessions#login_menu', as: 'login_menu_sessions'

end
