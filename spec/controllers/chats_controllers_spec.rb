require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe "POST #create" do
    let(:valid_prompt) { "Generate a creative story about space" }
    let(:invalid_prompt) { nil }

    context "when type is 'text'" do
      before do
        allow_any_instance_of(OpenaiService).to receive(:call).and_return({
                                                                            "choices" => [
                                                                              { "message" => { "content" => "Once upon a time in space..." } }
                                                                            ]
                                                                          })
      end

      it "returns the text response" do
        post :create, params: { prompt: valid_prompt, type: "text" }, format: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["reply"]).to eq("Once upon a time in space...")
      end
    end

    context "when type is 'image'" do
      before do
        allow_any_instance_of(OpenaiService).to receive(:call).and_return({
                                                                            "data" => [
                                                                              { "url" => "http://example.com/generated_image.png" }
                                                                            ]
                                                                          })
      end

      it "returns the image URL" do
        post :create, params: { prompt: valid_prompt, type: "image" }, format: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["image_url"]).to eq("http://example.com/generated_image.png")
      end
    end

    context "when no response is returned" do
      before do
        allow_any_instance_of(OpenaiService).to receive(:call).and_return(nil)
      end

      it "returns an error message" do
        post :create, params: { prompt: valid_prompt, type: "text" }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Unable to fetch a response")
      end
    end

    context "when prompt is invalid" do
      it "returns an error message" do
        post :create, params: { prompt: invalid_prompt, type: "text" }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Unable to fetch a response")
      end
    end
  end
end
