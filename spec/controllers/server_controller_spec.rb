require 'rails_helper'

RSpec.describe ServersController, type: :controller do
  let(:user) { create(:user) }
  let(:server) { create(:server) }
  let!(:user_server) { create(:user_server, user: user, server: server) }


  before do
    # Simulate a logged-in user by stubbing the current_user method
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "assigns user servers and all servers" do
      get :index
      expect(assigns(:user_servers)).to eq(user.user_servers.includes(:server))
      expect(assigns(:servers)).to eq(Server.all)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "assigns the requested server's details" do
      get :show, params: { id: server.id }
      expect(assigns(:users)).to eq(server.users)
      expect(assigns(:grid_tiles)).to eq(server.grid_tiles.order(:row, :column))
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new server and registers the user" do
        post :create, params: { server_status: "active" }
        created_server = Server.last
        expect(created_server.status).to eq("active")
        expect(user.servers).to include(created_server)
        expect(flash[:success]).to match(/Server created successfully/)
        expect(response).to redirect_to(servers_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a server and displays an error" do
        allow_any_instance_of(Server).to receive(:save).and_return(false)
        post :create, params: { server_status: "active" }
        expect(flash[:error]).to match(/Failed to create server/)
        expect(response).to redirect_to(servers_path)
      end
    end
  end

  describe "POST #add_user_custom" do
    context "when server exists" do
      it "registers the user if not already registered" do
        new_server = create(:server)
        post :add_user_custom, params: { server_number: new_server.id }
        expect(user.servers).to include(new_server)
        expect(flash[:success]).to match(/successfully joined server/)
        expect(response).to redirect_to(servers_path)
      end

      it "does not register the user if already registered" do
        post :add_user_custom, params: { server_number: server.id }
        expect(flash[:error]).to match(/already registered/)
        expect(response).to redirect_to(servers_path)
      end
    end

    context "when server does not exist" do
      it "displays an error" do
        post :add_user_custom, params: { server_number: 9999 }
        expect(flash[:error]).to match(/Server not found/)
        expect(response).to redirect_to(servers_path)
      end
    end
  end

  describe "GET #grid" do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      UserServer.find_or_create_by!(user: user, server: server)
    end

    it "assigns grid tiles and users on the grid" do
      get :grid, params: { id: server.id }
      expect(assigns(:grid_tiles)).to eq(server.grid_tiles.order(:row, :column))
      expect(assigns(:users_on_tiles)).to eq(server.grid_tiles.includes(:users))
    end
  end

  describe "POST #add_user" do
    it "registers the user to the server" do
      new_server = create(:server)
      post :add_user, params: { id: new_server.id }
      expect(user.servers).to include(new_server)
      expect(flash[:success]).to match(/successfully joined server/)
      expect(response).to redirect_to(servers_path)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the server" do
      delete :destroy, params: { id: server.id }
      expect(Server.exists?(server.id)).to be_falsey
      expect(flash[:success]).to match(/Server deleted successfully/)
      expect(response).to redirect_to(servers_path)
    end
  end
end
