class RemoveAdminFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :admin_id, :bigint
  end
end
