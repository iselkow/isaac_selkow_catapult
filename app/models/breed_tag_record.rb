class BreedTagRecord < ApplicationRecord
  belongs_to :breed
  belongs_to :tag
end
