class PlayersController < ApplicationController
  before_action :set_server, except: [:inventory]
  before_action :set_player, only: [:update_position, :current_position, :inventory]

  # Show the game grid
  def game_view
    @grid = build_grid
  end

  # Generate a story using the OpenAI API
  def generate_story
    prompt = "Write a short sci-fi story based on a player exploring a planet with #{@player.server.grid_tiles.find_by(row: @player.row, column: @player.column).weather} weather and #{@player.server.grid_tiles.find_by(row: @player.row, column: @player.column).environment_type} environment."

    service = OpenaiService.new(prompt: prompt, type: 'text')
    response = service.call
    story = response.dig("choices", 0, "message", "content") || "No story generated."
    end
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
  # Move the player to a specific tile
  def update_position
    position_params = params.require(:player).permit(:row, :column)
    target_row = position_params[:row].to_i
    target_column = position_params[:column].to_i

    if @player.move_to(target_row, target_column, current_user)
      render json: { success: true, message: "Player successfully moved to (#{target_row}, #{target_column})!" }, status: :ok
    else
      render json: { success: false, error: @player.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  # Prepares the grid with the player's position
  def build_grid
    return [] unless @player # Return an empty grid if no player is found

    (0..5).map do |row|
      (0..5).map do |column|
        {
          row: row,
          column: column,
          is_current: row == @player.row && column == @player.column
        }
      end
    end
  end
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
