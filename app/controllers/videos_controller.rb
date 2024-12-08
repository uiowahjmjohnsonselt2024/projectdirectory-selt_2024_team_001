class VideosController < ApplicationController

  def start_screen
    render 'menus/start_screen'
  end
  def sponsor_intro
    render 'menus/sponsor_intro'
  end

  def game_intro
    render 'menus/game_intro'
  end

  # No session flag, simply render the login menu after videos
  def end_intro
    render 'menus/login_menu'
  end
end
