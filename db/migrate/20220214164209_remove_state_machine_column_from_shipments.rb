class RemoveStateMachineColumnFromShipments < ActiveRecord::Migration[6.1]
  def change
    remove_column :shipments, :aasm_state
  end
end
