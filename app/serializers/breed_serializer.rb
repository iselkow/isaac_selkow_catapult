class BreedSerializer < ActiveModel::Serializer
  attributes :name
  has_many :tags
end
