#The SessionsController handles authentication-related actions, such as logging in and logging out.
# It’s solely responsible for managing user sessions.
# app/controllers/sessions_controller.rb
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new

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
        render 'menus/welcome_screen'
      else
        flash.now[:alert] = "Invalid email or password"
        render 'menus/login_menu'
      end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully!"
    redirect_to root_path
  end


end

