class AddStripeFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_monetize :orders, :amount, currency: { present: false }, null: false, default: 0
    add_column :orders, :checkout_session_id, :string

    add_index :orders, :checkout_session_id, unique: true
  end
end
