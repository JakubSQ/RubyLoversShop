class ChangeColumnValidationsInAddressTable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :addresses, :name, false
    change_column_null :addresses, :street_name1, false
    change_column_null :addresses, :city, false
    change_column_null :addresses, :country, false
    change_column_null :addresses, :state, false
    change_column_null :addresses, :zip, false
    change_column_null :addresses, :phone, false
  end
end
