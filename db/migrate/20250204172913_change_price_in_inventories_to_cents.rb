class ChangePriceInInventoriesToCents < ActiveRecord::Migration[7.1]
  def change
    rename_column :inventories, :price, :price_cents
  end
end
