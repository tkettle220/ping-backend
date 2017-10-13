class AddCustomPingPreferences < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :custom_ping_icons, :string, array: true, default: ['emergency', 'home', 'food']

    add_column :users, :custom_ping_messages, :string, array: true, default: ['Are you ok?', 'Hey, are you home?', 'Hey, want to get food?']
  end
end
