require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  let(:user) { create(:user) }
  let(:server) { create(:server) }
  let(:player) { create(:player, user: user, server: server, row: 0, column: 0) }

  before do
    # Simulate a logged-in user
    allow(controller).to receive(:current_user).and_return(user)
    # Assign the server and player for the actions
    allow(controller).to receive(:set_server).and_return(server)
    allow(controller).to receive(:set_player).and_return(player)
  end

  describe "GET #current_position" do
    it "returns the player's current position" do
      get :current_position, params: { server_id: server.id, id: player.id }, format: :json

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["position"]).to eq({ "row" => player.row, "column" => player.column })
    end

    it "returns an error if an exception occurs" do
      allow(controller).to receive(:set_player).and_raise(StandardError, "Player not found")

      get :current_position, params: { server_id: server.id, id: player.id }, format: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be false
      expect(json_response["error"]).to eq("Player not found")
    end
  end

  describe "PATCH #update_position" do
    context "with valid position" do
      it "updates the player's position and returns success" do
        patch :update_position, params: { server_id: server.id, id: player.id, player: { row: 1, column: 1 } }, format: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true
        expect(json_response["message"]).to eq("Player successfully moved to (1, 1)!")
        expect(player.reload.row).to eq(1)
        expect(player.reload.column).to eq(1)
      end
    end

    context "with invalid position" do
      it "returns an error if the target position is invalid" do
        allow(player).to receive(:move_to).and_return(false)
        player.errors.add(:base, "Invalid target position")

        patch :update_position, params: { server_id: server.id, id: player.id, player: { row: 10, column: 10 } }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("Invalid target position")
      end
    end
  end

  describe "GET #game_view" do
    it "assigns the grid and renders the game view template" do
      get :game_view, params: { server_id: server.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:grid)).not_to be_nil
      expect(response).to render_template(:game_view)
    end
  end
end
