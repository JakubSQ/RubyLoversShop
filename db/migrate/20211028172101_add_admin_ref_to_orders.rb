class AddAdminRefToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :admin, foreign_key: true
  end
end
