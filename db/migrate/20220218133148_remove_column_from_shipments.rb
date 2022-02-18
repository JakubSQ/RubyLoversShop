class RemoveColumnFromShipments < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :shipping_method_id, :integer
    remove_column :shipments, :name
    remove_column :shipments, :price
    remove_column :shipments, :delivery_time
  end
end
