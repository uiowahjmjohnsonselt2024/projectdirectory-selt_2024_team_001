require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user, password: "Password123!") }

  describe "GET #new" do
    it "redirects to root_path" do
      get :new
      expect(response).to redirect_to(root_path)
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
      it "sets the session user_id" do
        post :create, params: { email: user.email, password: "Password123!" }
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets a flash notice" do
        post :create, params: { email: user.email, password: "Password123!" }
        expect(flash[:notice]).to eq("Logged in successfully!")
      end

      it "renders the welcome_screen template" do
        post :create, params: { email: user.email, password: "Password123!" }
        expect(response).to render_template('menus/welcome_screen')
      end
    end

    context "with invalid credentials" do
      it "does not set the session user_id" do
        post :create, params: { email: user.email, password: "WrongPassword" }
        expect(session[:user_id]).to be_nil
      end

      it "sets a flash alert" do
        post :create, params: { email: user.email, password: "WrongPassword" }
        expect(flash[:alert]).to eq("Invalid email or password")
      end

      it "re-renders the login_menu template" do
        post :create, params: { email: user.email, password: "WrongPassword" }
        expect(response).to render_template('menus/login_menu')
      end
    end
  end

  describe "DELETE #destroy" do
    before { session[:user_id] = user.id }

    it "clears the session user_id" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it "sets a flash notice" do
      delete :destroy
      expect(flash[:notice]).to eq("Logged out successfully!")
    end

    it "redirects to the login_path" do
      delete :destroy
      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET #welcome_settings" do
    context "when user is logged in" do
      before { session[:user_id] = user.id }

      it "renders the welcome_settings template" do
        get :welcome_settings
        expect(response).to render_template('menus/welcome_settings')
      end
    end

    context "when user is not logged in" do
      it "redirects to login_path" do
        get :welcome_settings
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #main_game_screen" do
    context "when user is logged in" do
      before { session[:user_id] = user.id }

      it "renders the main_game_screen template" do
        get :main_game_screen
        expect(response).to render_template('menus/main_game_screen')
      end
    end

    context "when user is not logged in" do
      it "redirects to login_path" do
        get :main_game_screen
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #welcome_screen" do
    context "when user is logged in" do
      before { session[:user_id] = user.id }

      it "renders the welcome_screen template" do
        get :welcome_screen
        expect(response).to render_template('menus/welcome_screen')
      end
    end

    context "when user is not logged in" do
      it "redirects to login_path" do
        get :welcome_screen
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
