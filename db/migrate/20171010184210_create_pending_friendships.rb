class CreatePendingFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :pending_friendships do |t|
      t.integer :requester_id, null: false
      t.integer :requestee_id, null: false
      t.timestamps
    end

    add_index :pending_friendships, :requester_id
    add_index :pending_friendships, :requestee_id
    add_index :pending_friendships, [:requester_id, :requestee_id], unique: true
  end
end
