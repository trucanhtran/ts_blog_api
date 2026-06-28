class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :bio, :admin, :created_at, :updated_at
end
