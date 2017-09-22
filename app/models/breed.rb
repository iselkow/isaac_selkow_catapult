class Breed < ApplicationRecord
  has_many :breed_tag_records, dependent: :destroy
  has_many :tags, through: :breed_tag_records

  validates :name, presence: true, uniqueness: true

  def set_tags(tag_array)
    if tag_array.is_a? Array
      self.tags = tag_array.map { |tag_name| Tag.find_or_initialize_by(name: tag_name) }
    else
      self.tags = []
    end
  end
end
