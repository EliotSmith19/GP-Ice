class AddPriceToInventories < ActiveRecord::Migration[7.1]
  def change
    add_column :inventories, :price, :integer
  end
end
