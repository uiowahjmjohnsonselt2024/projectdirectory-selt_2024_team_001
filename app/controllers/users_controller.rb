#The UsersController is responsible for actions like signing up, viewing user profiles, editing account details,
# and possibly deleting accounts.
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # Ensure only logged-in users can access certain actions
  before_action :require_login, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new
    if @user.save
      session[:user_id] = @user.id  # Log the user in automatically
      flash[:notice] = "Welcome to Shards of the Grid!"
      redirect_to root_path
    else
      flash.now[:alert] = "There was a problem with your sign-up."
      render :new
    end
  end

  def show
    # Display the user's profile
  end

  def edit
    # Form to edit the user's account
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Account updated successfully!"
      redirect_to @user
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil  # Log the user out
    flash[:notice] = "Your account has been deleted."
    redirect_to root_path
  end

  private

  # Strong parameters to prevent mass assignment vulnerability
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end
end
