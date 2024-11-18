class ServersController < ApplicationController
  def index
    @servers = Server.all
  end

  def show
    @server = Server.find(params[:id])
    @grid_tiles = @server.grid_tiles
  end

  def create
    @server = Server.new(server_params)
    if @server.save
      redirect_to @server, notice: 'Server created successfully!'
    else
      render :new, alert: 'Error creating server.'
    end
  end

  private

  def server_params
    params.require(:server).permit(:name)
  end
end
