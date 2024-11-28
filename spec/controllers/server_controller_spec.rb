require 'spec_helper'
require 'rails_helper'

describe ServersController do
  describe 'Create a new Server' do
    it "should create a new Server and add it to your available server list" do
      pending("Route for 'create' is not implemented yet")
      post :create, params: { server: { name: 'Test Server' } }
      expect(response).to have_http_status(:redirect)
      expect(Server.last.name).to eq('Test Server')
    end

    it "The newly created server should be able to be joined" do
      pending("Server table is missing")
      server = Server.create!(name: 'Test Server')
      get :join, params: { id: server.id }
      expect(response).to have_http_status(:success)
      expect(assigns(:server)).to eq(server)
    end
  end

  describe 'Join an existing Server' do
    it 'should join an existing server and add it to your available server list' do
      pending("Server table is missing")
      server = Server.create!(name: 'Existing Server')
      post :join, params: { id: server.id }
      expect(response).to have_http_status(:redirect)
      expect(assigns(:server)).to eq(server)
    end
  end
end
