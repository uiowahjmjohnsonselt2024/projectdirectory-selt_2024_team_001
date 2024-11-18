#Handles the Actions once you've logged in such as joining, creating, and deleting server maps and characters. Might
# Handle the route for one of the potential shops we could implement.

class GameController < ApplicationController
  def grid
    @server = current_user.server
    @grid_tiles = @server.grid_tiles
    @current_tile = current_user.grid_tile
  end
end