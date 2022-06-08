class ChangeOrdersShipmentColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :shipping_method_id, :shipment_id
    add_foreign_key :orders, :shipments
    remove_foreign_key :orders, :shipping_methods
  end
end
