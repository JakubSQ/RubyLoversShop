class RenameStreetName1Column < ActiveRecord::Migration[6.1]
  def change
    rename_column :addresses, :street_name_1, :street_name1
    rename_column :addresses, :street_name_2, :street_name2
  end
end
