class AddColumnActiveToShipmentTable < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :active, :boolean, default: true
  end
end
