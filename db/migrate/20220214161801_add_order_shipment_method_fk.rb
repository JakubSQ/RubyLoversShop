class AddOrderShipmentMethodFk < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :orders, :shipping_methods
  end
end
