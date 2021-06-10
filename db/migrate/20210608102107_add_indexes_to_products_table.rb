class AddIndexesToProductsTable < ActiveRecord::Migration[6.1]
  def change
    add_index :products, :category_id
    add_index :products, :brand_id
  end
end
