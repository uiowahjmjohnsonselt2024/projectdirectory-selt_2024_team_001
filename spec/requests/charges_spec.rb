require 'rails_helper'

RSpec.describe "Charges", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/charges/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/charges/create"
      expect(response).to have_http_status(:success)
    end
  end

end
