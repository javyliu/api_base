class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :password_digest, presence: true
  validates :email, format: { with: /@/ }

  has_many :products, dependent: :destroy

  has_secure_password
end
