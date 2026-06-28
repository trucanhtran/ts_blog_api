class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :reactions, as: :reactionable, dependent: :destroy
  belongs_to :author, class_name: "User"

  validates :title, presence: true
  validates :content, presence: true
  validates :author_id, presence: true
end
