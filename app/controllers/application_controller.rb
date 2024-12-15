class ApplicationController < ActionController::Base
  # Protect from Cross-Site Request Forgery attacks
  protect_from_forgery with: :exception

  # Make current_user, logged_in?, and intro_watched? available to views
  helper_method :current_user, :logged_in?, :intro_watched?, :current_player

  private

  # Fetch the currently logged-in user based on the session
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_player
    @current_player ||= Player.find_by(user_id: current_user.id) if current_user
  end

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  # Check if a user is logged in
  def logged_in?
    current_user.present?
  end

  # Track if the intro videos have been watched
  def intro_watched?
    session[:intro_watched].present?
  end

  # Redirect unauthenticated users
  def require_login
    unless logged_in?
      flash.now[:alert] = "You must be logged in to access this section."
      redirect_to login_path # Adjust to your login route
    end
  end
end
