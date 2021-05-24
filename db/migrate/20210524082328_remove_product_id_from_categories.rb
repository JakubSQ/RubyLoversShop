class RemoveProductIdFromCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :product_id, :integer
  end
end
