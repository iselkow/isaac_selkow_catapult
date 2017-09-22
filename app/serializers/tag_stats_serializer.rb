class TagStatsSerializer < ActiveModel::Serializer
  attributes :id, :name
  attribute :breed_tag_records_count, key: :breed_count
  has_many :breed_tag_records, key: :breed_ids
  embed :ids
end
