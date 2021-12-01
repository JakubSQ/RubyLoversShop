class AddShippingAddressRefToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :shipping_address
  end
end
