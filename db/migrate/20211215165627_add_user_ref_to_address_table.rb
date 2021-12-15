class AddUserRefToAddressTable < ActiveRecord::Migration[6.1]
  def change
    add_reference :addresses, :user
  end
end
