require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject { FactoryGirl.build(:tag) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  it { is_expected.to have_many :breed_tag_records }
  it { is_expected.to have_many :breeds }
end
