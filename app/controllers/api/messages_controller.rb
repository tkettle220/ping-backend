class Api::MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.user = current_user
    if @message.save
      ActionCable.server.broadcast 'messages',
        message: message.content,
        user: message.user.name
      head :ok
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :channelId)
  end
end
