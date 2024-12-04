require 'spec_helper'
require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  let(:user) { User.create!(email: "test@example.com", password: "Password123!") }
  let(:achievement1) { Achievement.create!(name: "First Login", description: "Log in for the first time", user: user) }
  let(:achievement2) { Achievement.create!(name: "First Post", description: "Make your first post", user: user) }

  describe "GET #index" do
    context "when user exists" do
      before do
        # Associate achievements with the user
        achievement1
        achievement2
        get :index, params: { user_id: user.id }
      end

      it "assigns the user's achievements to @achievements" do
        expect(assigns(:achievements)).to match_array([achievement1, achievement2])
      end

      it "renders the achievements menu template" do
        expect(response).to render_template('menus/achievements')
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user does not exist" do
      it "raises an ActiveRecord::RecordNotFound error" do
        expect {
          get :index, params: { user_id: -1 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
