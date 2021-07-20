class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.integer :state, default: 0

      t.timestamps
    end
  end
end
