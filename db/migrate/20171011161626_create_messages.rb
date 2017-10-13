class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.integer :chatroom_id
      t.timestamps
    end

    add_index :messages, :user_id
    add_index :messages, :chatroom_id
  end
end
