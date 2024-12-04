class AchievementsController < ApplicationController
  before_action :set_user

  def index
    @achievements = @user.achievements
    render 'menus/achievements'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
