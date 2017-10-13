class AddChannelToFriendshipTable < ActiveRecord::Migration[5.1]
  def change
    add_column :friendships, :chat_room_id, :integer, null: false
    add_index :friendships, :chat_room_id
  end
end
