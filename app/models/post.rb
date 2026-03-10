class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :reactions, as: :reactionable, dependent: :destroy
  belongs_to :author
end
