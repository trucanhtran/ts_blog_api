class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author, class_name: "User"
  has_many :reactions, as: :reactionable, dependent: :destroy

  validates :content, presence: true
  validates :post_id, presence: true
  validates :author_id, presence: true
end
