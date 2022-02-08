class AddNewColumnsToShipments < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :name, :string, presence: true
    add_column :shipments, :price, :integer, presence: true
    add_column :shipments, :delivery_time, :integer, presence: true
  end
end
