class Order < ApplicationRecord
  belongs_to :user
  belongs_to :van

  has_one :review, dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products

  validates :user_id, :van_id, presence: true
  validates :confirmed_status, :paid_status, inclusion: { in: [true, false] }

  before_validation :set_default_status, on: :create

  validates :checkout_session_id, uniqueness: true, allow_nil: true
  monetize :amount_cents

  private

  def set_default_status
    self.confirmed_status = false if confirmed_status.nil?
    self.paid_status = false if paid_status.nil?
  end
end
