class CreateShipments < ActiveRecord::Migration[6.1]
  def change
    create_table :shipments do |t|
      t.string :aasm_state
      t.timestamps
    end
  end
end
