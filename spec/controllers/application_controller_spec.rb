# spec/controllers/application_controller_spec.rb
require 'spec_helper'
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Create a dummy controller to test ApplicationController methods
  controller do
    before_action :require_login, only: [:protected_action]

    def index
      render plain: "Welcome"
    end

    def protected_action
      render plain: "Protected"
    end
  end

  let(:user) { User.create!(email: "test@example.com", password: "Password123!") }

  describe "#current_user" do
    it "returns the user based on session user_id" do
      session[:user_id] = user.id
      expect(controller.send(:current_user)).to eq(user)
    end

    it "returns nil if there is no user_id in session" do
      session[:user_id] = nil
      expect(controller.send(:current_user)).to be_nil
    end
  end

  describe "#logged_in?" do
    it "returns true if a user is logged in" do
      session[:user_id] = user.id
      expect(controller.send(:logged_in?)).to be_truthy
    end

    it "returns false if no user is logged in" do
      session[:user_id] = nil
      expect(controller.send(:logged_in?)).to be_falsey
    end
  end

  describe "#require_login" do
    it "redirects to login path if user is not logged in" do
      get :protected_action
      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq("You must be logged in to access this section.")
    end

    it "does not redirect if user is logged in" do
      session[:user_id] = user.id
      get :protected_action
      expect(response).to have_http_status(:success)
      expect(response.body).to eq("Protected")
    end
  end
end
