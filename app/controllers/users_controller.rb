class UsersController < ApplicationController
  # Ensure only logged-in users can access certain actions
  before_action :require_login, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  attr_accessor :shards


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
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
    @user = current_user
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
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def set_user
    @user = current_user
  end

  def require_login
    unless current_user
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end
end
