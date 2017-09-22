class Breed < ApplicationRecord
  has_many :breed_tag_records, dependent: :destroy
  has_many :tags, through: :breed_tag_records

  validates :name, presence: true, uniqueness: true

  before_destroy :destroy_orphan_tags

  def set_tags(tag_array)
    if tag_array.is_a? Array
      self.tags = tag_array.map { |tag_name| Tag.find_or_initialize_by(name: tag_name) }
    else
      self.tags = []
    end
  end

  def destroy_orphan_tags
    tag_ids = tags.map(&:id)
    orphan_tag_ids = BreedTagRecord.where(tag_id: tag_ids).
                                    group(:tag_id).
                                    having('count(id) = 1').
                                    pluck(:tag_id)
    Tag.where(id: orphan_tag_ids).destroy_all
  end
end
