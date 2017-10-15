class PendingFriendship < ApplicationRecord
  validates :requester_id, uniqueness: { scope: :requestee_id }

  belongs_to :requester,
    foreign_key: :requester_id,
    class_name: "User",
    optional: true

  belongs_to :requestee,
    foreign_key: :requestee_id,
    class_name: "User",
    optional: true
end
