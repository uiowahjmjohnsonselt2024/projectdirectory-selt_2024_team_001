class PlayersController < ApplicationController
  before_action :set_server
  before_action :set_player, only: [:update_position, :current_position, :generate_story]

  # Generate a story using the OpenAI API
  def generate_story
    prompt = "Write a short sci-fi story based on a player exploring a planet with #{@player.server.grid_tiles.find_by(row: @player.row, column: @player.column).weather} weather and #{@player.server.grid_tiles.find_by(row: @player.row, column: @player.column).environment_type} environment."

    service = OpenaiService.new(prompt: prompt, type: 'text')
    response = service.call
    story = response.dig("choices", 0, "message", "content") || "No story generated."

    render json: { success: true, story: story }
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_server
    @server = Server.find(params[:server_id])
  end

  def set_player
    @player = @server.players.find(params[:id])
  end
end
