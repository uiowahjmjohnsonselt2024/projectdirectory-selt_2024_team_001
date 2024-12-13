class PlayersController < ApplicationController
  before_action :set_server
  before_action :set_player, only: [:update_position] # Add this for the new action

  def create
    @player = @server.players.new(player_params)
    @player.user = current_user

    if @player.save
      redirect_to server_path(@server), notice: "Player successfully created!"
    else
      redirect_to server_path(@server), alert: @player.errors.full_messages.to_sentence
    end
  end

  # New action to move a player to a specific tile
  def update_position
    player = Player.find(params[:id])
    row = params[:row].to_i
    column = params[:column].to_i

    if player.update_position(row, column)
      render json: { success: true }, status: :ok
    else
      render json: { error: "Failed to update position" }, status: :unprocessable_entity
    end
  end


  private

  def set_server
    @server = Server.find(params[:server_id])
  end

  def set_player
    @player = @server.players.find(params[:id]) # Find player within the server
  end

  def player_params
    params.require(:player).permit(:name) # Add more player-specific attributes if needed
  end
end
