class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :tokens do |t|
      t.string :value, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
    add_index :tokens, :user_id
  end
end
