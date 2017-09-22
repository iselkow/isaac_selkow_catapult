require 'rails_helper'

RSpec.describe Breed, type: :model do
  subject { FactoryGirl.build(:breed) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  it { is_expected.to have_many :breed_tag_records }
  it { is_expected.to have_many :tags }

  describe '#build_tags' do
    let!(:breed) { FactoryGirl.create(:breed) }
    let!(:tag_array) { ['Friendly'] }

    context 'with no existing tag' do
      it 'creates a new tag and breed_tag_record' do
        expect(Tag.count).to eq 0
        expect(BreedTagRecord.count).to eq 0

        breed.set_tags(tag_array)
        breed.save!

        expect(Tag.count).to eq 1
        expect(BreedTagRecord.count).to eq 1
        expect(breed.tags.pluck(:name)).to eq ['Friendly']
      end
    end

    context 'with an existing tag' do
      let!(:tag) { FactoryGirl.create(:tag, name: 'Friendly') }

      it 'creates a new breed_tag_record' do
        expect(Tag.count).to eq 1
        expect(BreedTagRecord.count).to eq 0

        breed.set_tags(tag_array)
        breed.save!

        expect(Tag.count).to eq 1
        expect(BreedTagRecord.count).to eq 1
        expect(breed.tags.pluck(:name)).to eq ['Friendly']
      end

      context 'and an existing link to the breed' do
        let!(:breed_tag_record) { FactoryGirl.create(:breed_tag_record, breed: breed, tag: tag) }

        it 'does not create a new record' do
          expect(Tag.count).to eq 1
          expect(BreedTagRecord.count).to eq 1

          breed.set_tags(tag_array)
          breed.save!

          expect(Tag.count).to eq 1
          expect(BreedTagRecord.count).to eq 1
          expect(breed.tags.pluck(:name)).to eq ['Friendly']
        end
      end
    end
  end
end
