class AddShipmentRefToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :shipment, foreign_key: true
  end
end
