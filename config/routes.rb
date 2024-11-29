Rails.application.routes.draw do
  # Root route pointing to the sponsor intro video (view, not a direct video file)
  root 'videos#sponsor_intro'

  # Routes for user sign-up, account management, etc.
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]

  # Custom route for user sign-up
  get 'signup', to: 'users#new', as: :signup

  # Session management routes (assuming you want login/logout functionality)
  get 'login', to: 'sessions#new', as: :login
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: :logout


  # Routes for screens after login
  get 'welcome_screen', to: 'sessions#welcome_screen', as: 'welcome_screen'
  get 'main_game_screen', to: 'sessions#main_game_screen', as: 'main_game_screen'
  get 'welcome_settings', to: 'sessions#welcome_settings', as: 'welcome_settings'

  # Route for the sponsor intro video (view, not the file itself)
  get 'videos/sponsor_intro', to: 'videos#sponsor_intro', as: 'sponsor_intro'

  # Route for the game intro video (view, not the file itself)
  get 'videos/game_intro', to: 'videos#game_intro', as: 'game_intro'

  # Route to render the login page after videos are watched
  get 'videos/end_intro', to: 'videos#end_intro', as: 'end_intro'
end
