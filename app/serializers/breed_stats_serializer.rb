class BreedStatsSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :breed_tag_records_count, key: :tag_count
  has_many :breed_tag_records, key: :tag_ids
  embed :ids
end
