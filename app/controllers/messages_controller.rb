# app/controllers/messages_controller.rb

class MessagesController < ApplicationController
  def create
    @server = Server.find(params[:server_id])
    @message = @server.messages.new(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        # Automatic Turbo Streams broadcast
        format.turbo_stream
        format.html { redirect_to game_view_server_path(@server) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
