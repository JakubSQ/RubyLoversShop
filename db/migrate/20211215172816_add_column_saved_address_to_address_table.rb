class AddColumnSavedAddressToAddressTable < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :saved, :boolean, default: false
  end
end
