class ServerChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a server-specific channel
    stream_from "server_#{params[:server_id]}_channel"
  end

  def receive(data)
    # Broadcast message to the specific server channel
    server_id = data['server_id']
    message = data['message']
    user_id = data['user_id']

    # Optional: You might want to persist the message or perform additional logic
    broadcast_data = {
      message: message,
      user_id: user_id,
      timestamp: Time.current
    }

    ActionCable.server.broadcast("server_#{server_id}_channel", broadcast_data)
  end
end