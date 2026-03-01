class User < ApplicationRecord
  has_many :comments, dependent: :nullify
  has_many :reactions, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
