class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :password_digest, presence: true
  validates :email, format: { with: /@/ }

  has_secure_password
end
