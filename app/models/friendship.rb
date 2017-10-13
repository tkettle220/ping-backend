class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  belongs_to :chatroom,
    foreign_key: :chatroom_id,
    class_name: "Chatroom",
    dependent: :destroy
end
