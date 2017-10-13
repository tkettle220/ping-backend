class FixDefaultPingMessages < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :custom_ping_icons, ['emergency','home','food',]

    change_column_default :users, :custom_ping_messages, ['Are you ok?','Hey, are you home?','Hey, want to get food?',]
  end
end
