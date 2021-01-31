class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :password_digest, presence: true
  validates :email, format: { with: /@/ }

  has_many :products, dependent: :destroy, inverse_of: :user

  has_secure_password

  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
end
