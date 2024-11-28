# spec/controllers/sessions_controller_spec.rb
require 'spec_helper'
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", password: "Password123!") }

  describe "GET #new" do
    it "renders the new (login) template" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #login_menu" do
    it "renders the login_menu template" do
      get :login_menu
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

  describe "DELETE #destroy" do
    it "logs out the user and redirects to the root path" do
      session[:user_id] = user.id
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(flash[:notice]).to eq("Logged out successfully!")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #welcome_settings" do
    it "renders the welcome_settings template" do
      get :welcome_settings
      expect(response).to render_template('menus/welcome_settings')
    end
  end

  describe "GET #main_game_screen" do
    it "renders the main_game_screen template" do
      get :main_game_screen
      expect(response).to render_template('menus/main_game_screen')
    end
  end

  describe "GET #welcome_screen" do
    it "renders the welcome_screen template" do
      get :welcome_screen
      expect(response).to render_template('menus/welcome_screen')
    end
  end
end
