class Inventory < ApplicationRecord
  belongs_to :product
  belongs_to :van

  validates :product_id, :van_id, presence: true
  validates :quantity_available, presence: true, numericality: { greater_than: 0 }

end
