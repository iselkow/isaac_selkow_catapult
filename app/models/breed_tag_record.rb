class BreedTagRecord < ApplicationRecord
  belongs_to :breed, counter_cache: true
  belongs_to :tag, counter_cache: true
end
