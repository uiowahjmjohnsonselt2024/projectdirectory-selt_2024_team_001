require Rails.root.join('app/services/openai_service')
class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    prompt = params[:prompt]
    type = params[:type] # 'text' or 'image'

    response = OpenAIService.new(prompt: prompt, type: type).call

    if response
      if type == 'text'
        render json: { reply: response.dig("choices", 0, "message", "content") }
      elsif type == 'image'
        render json: { image_url: response.dig("data", 0, "url") }
      end
    else
      render json: { error: "Unable to fetch a response" }, status: :unprocessable_entity
    end
  end
end
