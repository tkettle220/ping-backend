class AddUserFindableColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :findable, :boolean, default: true
  end
end
