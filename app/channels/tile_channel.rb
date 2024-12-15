# app/channels/tile_channel.rb
class TileChannel < ApplicationCable::Channel
  def subscribed
    tile_id = params[:tile_id]

    if valid_tile?(tile_id)
      stream_from "tile_#{tile_id}_channel"
      # Notify others on the tile that a new user has joined (optional)
      ActionCable.server.broadcast("tile_#{tile_id}_channel", message: "#{current_user.email} has joined this tile.")
    else
      reject
    end
  end

  def unsubscribed
    # Notify others on the tile that the user has left (optional)
    tile_id = params[:tile_id]
    ActionCable.server.broadcast("tile_#{tile_id}_channel", message: "#{current_user.email} has left this tile.") if valid_tile?(tile_id)
  end

  # Action to handle custom client events (e.g., ping from a specific user)
  def ping(data)
    tile_id = params[:tile_id]
    if valid_tile?(tile_id)
      ActionCable.server.broadcast(
        "tile_#{tile_id}_channel",
        message: "#{current_user.email} pinged the tile: #{data['custom_message'] || 'Hello!'}"
      )
    else
      reject
    end
  end

  private

  def valid_tile?(tile_id)
    # Ensure the tile exists in the database
    GridTile.exists?(id: tile_id)
  end
end
