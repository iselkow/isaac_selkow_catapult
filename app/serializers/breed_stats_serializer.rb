class BreedStatsSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :breed_tag_records_count, key: :tag_count
  has_many :tags
  embed :ids
end
