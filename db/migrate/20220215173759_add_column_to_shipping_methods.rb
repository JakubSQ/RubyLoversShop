class AddColumnToShippingMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_methods, :active, :boolean, default: true
  end
end
