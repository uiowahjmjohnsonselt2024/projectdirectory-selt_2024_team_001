#The SessionsController handles authentication-related actions, such as logging in and logging out.
# It’s solely responsible for managing user sessions.
# app/controllers/sessions_controller.rb
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController

  before_action :require_login, only: [:welcome_screen, :welcome_settings, :main_game_screen]
  def new
    redirect_to root_path
  end
  def login_menu
    render 'menus/login_menu'
  end

  def create
      # Real user authentication
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "Logged in successfully!"
        # Grant "First Login" achievement if it's the user's first login
        unless user.unlocked_achievement?('First Login')
          Achievement.unlock_for_user(user, 'First Login', 'Logged in for the first time')
        end
        render 'menus/welcome_screen'
      else
        flash.now[:alert] = "Invalid email or password"
        render 'menus/login_menu'
      end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully!"
    redirect_to login_path
  end

  def toggle_theme
    session[:theme] = params[:theme_toggle] == 'light' ? 'light' : 'dark'
    redirect_to welcome_settings_path, notice: "Theme updated to #{session[:theme]} mode."
  end

  def update_session_profile_picture
    session[:profile_picture] = params[:profile_picture]
    render json: { success: true }
  end

  def welcome_settings
    render 'menus/welcome_settings'
  end

  def main_game_screen
    render 'menus/main_game_screen'
  end

  def welcome_screen
    render 'menus/welcome_screen'
  end

  def user_profile
    render 'menus/user_profile'
  end

  def achievements
    @achievements = [
      { name: "First Achievement" },
      { name: "Second Achievement" },
      { name: "Third Achievement" }
    ]
    render 'menus/achievements'
  end



  def shard_purchase
    render 'charges/shard_purchase'
  end

end

