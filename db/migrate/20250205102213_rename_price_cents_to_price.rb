class RenamePriceCentsToInventory < ActiveRecord::Migration[7.1]
  def change
    rename_column :inventories, :price_cents, :price
  end
end
