require 'spec_helper'
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", password: "Password123!", password_confirmation: "Password123!") }

  describe "GET #new" do
    it "assigns a new User to @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user and logs them in" do
        expect {
          post :create, params: { user: { email: "newuser@example.com", password: "Password123!", password_confirmation: "Password123!" } }
        }.to change(User, :count).by(1)

        expect(session[:user_id]).to eq(User.last.id)
        expect(flash[:notice]).to eq("Welcome to Shards of the Grid!")
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a new user and re-renders the :new template" do
        expect {
          post :create, params: { user: { email: "", password: "123", password_confirmation: "456" } }
        }.not_to change(User, :count)

        expect(flash.now[:alert]).to eq("There was a problem with your sign-up.")
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #show" do
    context "when logged in" do
      before { session[:user_id] = user.id }
    end

    context "when not logged in" do
      it "redirects to the login page with an alert" do
        get :show, params: { id: user.id }
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET #edit" do
    context "when logged in" do
      before { session[:user_id] = user.id }
    end

    context "when not logged in" do
      it "redirects to the login page with an alert" do
        get :edit, params: { id: user.id }
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "when logged in" do
      before { session[:user_id] = user.id }

      it "updates the user's attributes and redirects to the show page" do
        patch :update, params: { id: user.id, user: { email: "updated@example.com" } }
        expect(user.reload.email).to eq("updated@example.com")
        expect(flash[:notice]).to eq("Account updated successfully!")
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "when not logged in" do
      it "redirects to the login page with an alert" do
        patch :update, params: { id: user.id, user: { email: "updated@example.com" } }
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when logged in" do
      before { session[:user_id] = user.id }

      it "deletes the user and logs them out" do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)

        expect(session[:user_id]).to be_nil
        expect(flash[:notice]).to eq("Your account has been deleted.")
        expect(response).to redirect_to(root_path)
      end
    end

    context "when not logged in" do
      it "redirects to the login page with an alert" do
        delete :destroy, params: { id: user.id }
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
