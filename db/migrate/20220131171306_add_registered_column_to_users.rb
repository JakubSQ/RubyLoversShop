class AddRegisteredColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :registered, :boolean, null: false, default: true
  end
end
