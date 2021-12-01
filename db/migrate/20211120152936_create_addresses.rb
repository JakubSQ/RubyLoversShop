class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :street_name_1
      t.string :street_name_2
      t.string :city
      t.string :country
      t.string :state
      t.string :zip
      t.string :phone
      t.timestamps
    end
  end
end
