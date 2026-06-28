class User < ApplicationRecord
  # devise modules for API authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :comments, dependent: :nullify
  has_many :reactions, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
