class AddColumnShipToBillToAddressTable < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :ship_to_bill, :boolean, default: false
  end
end
