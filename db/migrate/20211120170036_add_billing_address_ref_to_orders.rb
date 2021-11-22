class AddBillingAddressRefToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :billing_address
  end
end
