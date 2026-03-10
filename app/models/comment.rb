class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :author
  has_many :reactions, as: :reactionable, dependent: :destroy
end
