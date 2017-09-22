class Breed < ApplicationRecord
  has_many :breed_tag_records, dependent: :destroy
  has_many :tags, through: :breed_tag_records

  validates :name, presence: true, uniqueness: true
end
