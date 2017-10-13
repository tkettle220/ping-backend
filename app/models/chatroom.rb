class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages

  has_many :friend_pairs,
    foreign_key: :chatroom_id,
    class_name: "Friendship"
end
