require 'rails_helper'

RSpec.describe BreedTagRecord, type: :model do
  subject { FactoryGirl.build(:breed_tag_record) }

  it { is_expected.to belong_to :breed }
  it { is_expected.to belong_to :tag }
end
