class CreateShippingMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_methods do |t|
      t.string :aasm_state
      t.string :name
      t.integer :price
      t.integer :delivery_time

      t.timestamps
    end
  end
end
