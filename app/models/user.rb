class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_one_attached :image
  has_one :van, dependent: :destroy
  has_many :orders
  has_many :favourites
  has_many :favourite_vans, through: :favourites, source: :van

  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }

  validates :email, :password, presence: true


  def van_owner?
    van.present?
  end

end
