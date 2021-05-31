class AddBrandIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :brand_id, :integer
  end
end
