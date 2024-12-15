# app/controllers/messages_controller.rb

class MessagesController < ApplicationController

  # messages_controller.rb
  def index
    @messages = @single_room.messages.order(created_at: :asc).last(50)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

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
