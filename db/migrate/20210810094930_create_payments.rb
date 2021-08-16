class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.string :name
      t.string :aasm_state

      t.timestamps
    end
  end
end
