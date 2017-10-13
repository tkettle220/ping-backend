class RemoveColumnFromChatroom < ActiveRecord::Migration[5.1]
  def change
    remove_column :chatrooms, :chatname
    rename_column :friendships, :chat_room_id, :chatroom_id
  end
end
