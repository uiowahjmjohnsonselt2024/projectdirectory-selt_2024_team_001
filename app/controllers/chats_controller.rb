class ChatsController < ApplicationController
  def create
    prompt = params[:prompt]
    response = OpenAIService.new(prompt).call

    if response
      render json: { reply: response.dig("choices", 0, "message", "content") }
    else
      render json: { error: "Unable to fetch a response" }, status: :unprocessable_entity
    end
  end
end
