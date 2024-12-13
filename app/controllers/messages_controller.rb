class MessagesController < ApplicationController
  def create
    @server = Server.find(params[:server_id])
    @message = @server.messages.new(message_params)
    @message.user = current_user

    if @message.save
      Turbo::StreamsChannel.broadcast_replace_to(
        @server, target: 'messages', partial: 'messages/message', locals: { message: @message }
      )

    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
