class Api::MessagesController < ApplicationController
  def create
    @message = Message.new({content: params[:message][:content], chatroom_id: params[:message][:channelId]})
    @message.user_id = 1
    if @message.save
      ActionCable.server.broadcast "messages",
      # ActionCable.server.broadcast "messages_#{params[:chat_room_id]}",
        content: @message.content,
        user: @message.user.name
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
