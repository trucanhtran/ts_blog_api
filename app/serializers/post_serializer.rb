class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :created_at, :updated_at

  # If you have associations, include them like:
  # has_many :comments, serializer: CommentSerializer
  # belongs_to :author, serializer: UserSerializer

  # Custom computed attributes:
  attribute :summary do
    object.content&.truncate(100)
  end

  attribute :word_count do
    object.content&.split&.length || 0
  end
end
