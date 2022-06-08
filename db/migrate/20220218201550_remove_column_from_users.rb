class RemoveColumnFromUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :email, :string
    remove_column :users, :registered
  end
end
