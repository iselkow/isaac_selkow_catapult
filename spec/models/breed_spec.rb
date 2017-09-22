require 'rails_helper'

RSpec.describe Breed, type: :model do
  subject { FactoryGirl.build(:breed) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
end
