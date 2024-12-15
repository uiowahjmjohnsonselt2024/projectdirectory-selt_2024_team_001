class PlayersController < ApplicationController
  before_action :set_server
  before_action :set_player, only: [:update_position, :current_position]

  # Show the game grid
  def game_view
    @grid = build_grid
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
    @player = @server.players.find(params[:id])
  end
end
