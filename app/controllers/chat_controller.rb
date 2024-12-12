class ChatController < ApplicationController
  def index
    @messages = Message.all # Assuming you have a Message model
  end

  def create
    message = Message.new(message_params)

    if message.save
      ActionCable.server.broadcast "chat_channel",
                                   message: message.content

      render json: { status: 'success' }, status: :created
    else
      render json: { status: 'error', errors: message.errors }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end