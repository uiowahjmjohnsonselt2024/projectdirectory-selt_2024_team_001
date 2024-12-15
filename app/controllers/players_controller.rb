class PlayersController < ApplicationController
  before_action :set_server, except: [:inventory]
  before_action :set_player, only: [:update_position, :current_position, :inventory]

  # Generate a story using the OpenAI API
  def generate_story
    prompt = "Write a short sci-fi story based on a player exploring a planet with #{@player.server.grid_tiles.find_by(row: @player.row, column: @player.column).weather} weather and #{@player.server.grid_tiles.find_by(row: @player.row, column: @player.column).environment_type} environment."

    service = OpenaiService.new(prompt: prompt, type: 'text')
    response = service.call
    story = response.dig("choices", 0, "message", "content") || "No story generated."

  def inventory
    @player_items = @player.player_items.includes(:store_item)
      render 'menus/inventory'  # Explicitly render the correct view
    end


  # Fetch the current position of the player
  def current_position
    render json: { success: true, position: { row: @player.row, column: @player.column } }
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_server
    @server = Server.find(params[:server_id])
  end

  def set_player
    if params[:server_id]
      @player = @server.players.find(params[:id])
    else
      @player = Player.find(params[:id]) # For inventory and standalone player actions
    end
  end
end
