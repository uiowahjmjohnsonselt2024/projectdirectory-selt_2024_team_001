require 'spec_helper'
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", password: "Password123!") }

  describe "GET #login_menu" do
    it "renders the login_menu template" do
      get :login_menu
      expect(response).to have_http_status(:success)
      expect(response).to render_template('menus/login_menu')
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      it "logs in the user and renders the welcome screen" do
        post :create, params: { email: user.email, password: "Password123!" }
        expect(session[:user_id]).to eq(user.id)
        expect(flash[:notice]).to eq("Logged in successfully!")
        expect(response).to render_template('menus/welcome_screen')
      end
    end

    context "with invalid credentials" do
      it "does not log in the user and re-renders the login menu" do
        post :create, params: { email: user.email, password: "wrongpassword" }
        expect(session[:user_id]).to be_nil
        expect(flash.now[:alert]).to eq("Invalid email or password")
        expect(response).to render_template('menus/login_menu')
      end
    end
  end

  describe "GET #welcome_settings" do
    context "when user is logged in" do
      it "renders the welcome_settings template" do
        session[:user_id] = user.id
        get :welcome_settings
        expect(response).to render_template('menus/welcome_settings')
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get :welcome_settings
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this section.")
      end
    end
  end

  describe "GET #main_game_screen" do
    context "when user is logged in" do
      it "renders the main_game_screen template" do
        session[:user_id] = user.id
        get :main_game_screen
        expect(response).to render_template('menus/main_game_screen')
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get :main_game_screen
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this section.")
      end
    end
  end

  describe "GET #welcome_screen" do
    context "when user is logged in" do
      it "renders the welcome_screen template" do
        session[:user_id] = user.id
        get :welcome_screen
        expect(response).to render_template('menus/welcome_screen')
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get :welcome_screen
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this section.")
      end
    end
  end
end
