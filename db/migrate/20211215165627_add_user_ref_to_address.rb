class AddUserRefToAddress < ActiveRecord::Migration[6.1]
  def change
    add_reference :addresses, :user, index: true
  end
end
