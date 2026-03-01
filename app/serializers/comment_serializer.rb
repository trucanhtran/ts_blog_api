class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :author, :post_id, :created_at, :updated_at

  # If you have associations, include them like:
  # belongs_to :author, serializer: UserSerializer
end
