class PlayersController < ApplicationController
  before_action :set_server

  def create
    @player = @server.players.new(player_params)
    @player.user = current_user

    if @player.save
      redirect_to server_path(@server), notice: "Player successfully created!"
    else
      redirect_to server_path(@server), alert: @player.errors.full_messages.to_sentence
    end
  end

  private

  def set_server
    @server = Server.find(params[:server_id])
  end

  def player_params
    params.require(:player).permit(:name) # Add more player-specific attributes if needed
  end
end
