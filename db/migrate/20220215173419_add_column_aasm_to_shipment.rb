class AddColumnAasmToShipment < ActiveRecord::Migration[6.1]
  def change
    add_column :shipments, :aasm_state, :string
  end
end
