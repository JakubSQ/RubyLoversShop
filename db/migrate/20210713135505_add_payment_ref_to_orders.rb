class AddPaymentRefToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :payment, foreign_key: true
  end
end
