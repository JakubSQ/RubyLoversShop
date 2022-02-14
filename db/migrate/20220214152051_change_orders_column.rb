class ChangeOrdersColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :orders, :shipment_id, :shipping_method_id
  end
end
