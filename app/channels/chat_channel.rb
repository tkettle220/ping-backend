class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "messages"
    # stream_from "messages_#{params[:chat_room_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  #
  # def receive(payload)
  #   message = Message.create(chatroom_id: payload["chatroom_id"], content: payload["message"])
  #   ActionCable.server.broadcast('messages', {message: message.content, chatroom_id: message.chatroom_id})
  # end
end
