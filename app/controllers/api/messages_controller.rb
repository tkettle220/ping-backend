class Api::MessagesController < ApplicationController
  def create
    @message = Message.new({content: params[:content], chatroom_id: params[:chatroom_id]})
    @message.user_id = current_user.id
    if @message.save
      ActionCable.server.broadcast "messages_#{params[:chatroom_id]}",
        content: @message.content,
        user: @message.user.name
      head :ok
    else
      render json: @message.errors.full_messages, status: 422
    end
  end

  def show
    @messages = Message.includes(:user).where(chatroom_id: params[:id])
    render "api/messages/show"
  end
end
