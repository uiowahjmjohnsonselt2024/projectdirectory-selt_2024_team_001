class VideosController < ApplicationController
  before_action :require_login # Ensure the user is logged in before showing the videos

  def intro
    if params[:welcome]
      render 'sessions/welcome_screen'
    else
      # This action will render the view that plays the introductory videos.
      render 'menus/intro'
    end
  end

  def main_screen
    # This action will render the main screen of the game after the intro videos
  end
end
