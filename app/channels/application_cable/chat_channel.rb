# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast("chat_#{params[:room]}", message: render_message(data['message']))
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'chats/message', locals: { message: message, user: current_user })
  end
end
