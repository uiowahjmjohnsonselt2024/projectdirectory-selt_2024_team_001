# app/channels/chat_channel.rb
class ServerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:server_id]}"
  end

  def receive(data)
    ActionCable.server.broadcast(
      "chat_#{params[:server_id]}",
      message: render_message(data['message'], current_user)
    )
  end

  private

  def render_message(message, user)
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals: { message:, user: }
    )
  end
end