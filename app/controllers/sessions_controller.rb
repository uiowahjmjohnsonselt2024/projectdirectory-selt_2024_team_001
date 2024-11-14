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
end

