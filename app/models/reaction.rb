class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactionable, polymorphic: true

  validates :kind, presence: true, inclusion: { in: %w[like love laugh angry sad wow] }
  validates :user_id, uniqueness: { scope: [ :reactionable_type, :reactionable_id, :kind ] }

  scope :likes, -> { where(kind: "like") }
  scope :loves, -> { where(kind: "love") }
  scope :laughs, -> { where(kind: "laugh") }
  scope :angry, -> { where(kind: "angry") }
  scope :sad, -> { where(kind: "sad") }
  scope :wow, -> { where(kind: "wow") }
end
