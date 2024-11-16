class ApplicationController < ActionController::Base
  # Protect from Cross-Site Request Forgery attacks
  protect_from_forgery with: :exception

  # Make current_user available to views
  helper_method :current_user, :logged_in?

  private

  # Fetch the currently logged-in user based on the session
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Check if a user is logged in
  def logged_in?
    current_user.present?
  end

  # Redirect unauthenticated users
  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this section."
      redirect_to login_path # Adjust to your login route
    end
  end
end
