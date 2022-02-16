class RemoveColumnActiveAndAasmState < ActiveRecord::Migration[6.1]
  def change
    remove_column :shipping_methods, :aasm_state
    remove_column :shipments, :active
  end
end
