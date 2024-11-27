require 'rails_helper'

RSpec.describe ServersController, type: :controller do
  let!(:server) { create(:server) }
  let!(:user) { create(:user) }

  describe "GET #index" do
    it "assigns all servers to @servers" do
      get :index
      expect(assigns(:servers)).to eq([server])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "assigns the requested server to @server" do
      get :show, params: { id: server.id }
      expect(assigns(:server)).to eq(server)
    end

    it "assigns users and grid_cells" do
      get :show, params: { id: server.id }
      expect(assigns(:users)).to eq(server.users)
      expect(assigns(:grid_cells)).to eq(server.grid_tiles.order(:row, :column))
    end

    it "renders the show template" do
      get :show, params: { id: server.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns a new server to @server" do
      get :new
      expect(assigns(:server)).to be_a_new(Server)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new server" do
        expect {
          post :create, params: { server: attributes_for(:server) }
        }.to change(Server, :count).by(1)
      end

      it "redirects to the new server" do
        post :create, params: { server: attributes_for(:server) }
        expect(response).to redirect_to(Server.last)
      end
    end

    context "with invalid attributes" do
      it "does not save the server" do
        expect {
          post :create, params: { server: { server_num: nil, status: nil } }
        }.not_to change(Server, :count)
      end

      it "re-renders the new template" do
        post :create, params: { server: { server_num: nil, status: nil } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid attributes" do
      it "updates the server" do
        patch :update, params: { id: server.id, server: { status: "Closed" } }
        server.reload
        expect(server.status).to eq("Closed")
      end

      it "redirects to the server" do
        patch :update, params: { id: server.id, server: { status: "Closed" } }
        expect(response).to redirect_to(server)
      end
    end

    context "with invalid attributes" do
      it "does not update the server" do
        patch :update, params: { id: server.id, server: { server_num: nil } }
        server.reload
        expect(server.server_num).not_to be_nil
      end

      it "re-renders the edit template" do
        patch :update, params: { id: server.id, server: { server_num: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the server" do
      expect {
        delete :destroy, params: { id: server.id }
      }.to change(Server, :count).by(-1)
    end

    it "redirects to the servers index" do
      delete :destroy, params: { id: server.id }
      expect(response).to redirect_to(servers_path)
    end
  end

  describe "POST #add_user" do
    context "when user is not already in the server" do
      it "adds the user to the server" do
        expect {
          post :add_user, params: { id: server.id, user_id: user.id }
        }.to change { server.users.count }.by(1)
      end

      it "assigns the user to a starting tile" do
        post :add_user, params: { id: server.id, user_id: user.id }
        user_server = UserServer.find_by(user: user, server: server)
        expect(user_server.grid_cell).to eq(server.grid_tiles.find_by(row: 1, column: 1))
      end

      it "redirects to the server" do
        post :add_user, params: { id: server.id, user_id: user.id }
        expect(response).to redirect_to(server)
      end
    end

    context "when user is already in the server" do
      before do
        server.users << user
      end

      it "does not add the user again" do
        expect {
          post :add_user, params: { id: server.id, user_id: user.id }
        }.not_to change { server.users.count }
      end

      it "sets a flash error message" do
        post :add_user, params: { id: server.id, user_id: user.id }
        expect(flash[:error]).to eq("User is already a member of this server.")
      end
    end
  end

  describe "GET #grid" do
    it "assigns grid_cells and users_on_grid" do
      get :grid, params: { id: server.id }
      expect(assigns(:grid_cells)).to eq(server.grid_tiles.order(:row, :column))
      expect(assigns(:users_on_grid)).to eq(server.grid_tiles.includes(:users))
    end

    it "renders the grid template" do
      get :grid, params: { id: server.id }
      expect(response).to render_template(:grid)
    end
  end
end
