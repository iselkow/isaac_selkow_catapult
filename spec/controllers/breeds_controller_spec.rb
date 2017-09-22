require 'rails_helper'

RSpec.describe BreedsController, type: :controller do
  let(:valid_attributes) { { name: FFaker::Name.name, tags: [FFaker::Music.artist, FFaker::Music.artist] } }

  describe "GET #index" do
    before do
      3.times { FactoryGirl.create(:breed) }
      get :index
    end

    it "returns an array of breeds" do
      json_response = JSON.parse(response.body, symbolize_names: true)[:breeds]
      expect(json_response.count).to eq 3
      expect(json_response.first[:name]).to eq Breed.first.name
      expect(response.status).to eq 200
    end
  end

  describe "GET #show" do
    let(:breed) { FactoryGirl.create(:breed, :with_tag, tag_count: 2) }

    it "returns a breed and its tags" do
      get :show, params: { id: breed.id }
      json_response = JSON.parse(response.body, symbolize_names: true)[:breed]
      expect(json_response[:name]).to eq breed.name
      expect(json_response[:tags].count).to eq 2
      expect(json_response[:tags].map { |tag| tag[:name] }).to match_array Tag.pluck(:name)
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Breed, new Tags, and new BreedTagRecords" do
        expect(Breed.count).to eq 0
        expect(Tag.count).to eq 0
        expect(BreedTagRecord.count).to eq 0

        post :create, params: {breed: valid_attributes}

        expect(Breed.count).to eq 1
        expect(Tag.count).to eq 2
        expect(BreedTagRecord.count).to eq 2
      end

      it "renders a JSON response with the new breed" do
        post :create, params: {breed: valid_attributes}
        json_response = JSON.parse(response.body, symbolize_names: true)[:breed]
        expect(json_response[:name]).to eq valid_attributes[:name]
        expect(json_response[:tags].count).to eq 2
        expect(response.status).to eq 201
      end

      context 'when one of the tags already exists' do
        let!(:tag) { FactoryGirl.create(:tag) }
        let(:valid_attributes) { { name: FFaker::Name.name, tags: [FFaker::Music.artist, tag.name] } }

        it 'only creates one new tag, and a new BreedTagRecord linking to it' do
          expect(Breed.count).to eq 0
          expect(Tag.count).to eq 1
          expect(BreedTagRecord.count).to eq 0

          post :create, params: {breed: valid_attributes}

          expect(Breed.count).to eq 1
          expect(Tag.count).to eq 2
          expect(BreedTagRecord.count).to eq 2

          expect(BreedTagRecord.find_by(tag: tag)).to be_present
        end
      end
    end

    context "with invalid params" do
      let!(:breed) { FactoryGirl.create(:breed) }

      it "renders a JSON response with errors for the new breed" do
        post :create, params: {breed: { name: breed.name } }
        json_response = JSON.parse(response.body, symbolize_names: true)[:errors]
        expect(json_response[:name]).to include 'has already been taken'
        expect(response.status).to eq 422
      end
    end
  end

  describe "PUT #update" do
    let!(:breed) { FactoryGirl.create(:breed) }

    context "with valid params" do
      let(:new_attributes) { { name: FFaker::Name.name } }

      it "updates the requested breed" do
        put :update, params: {id: breed.id, breed: new_attributes}
        breed.reload
        expect(breed.name).to eq new_attributes[:name]
      end

      it "renders a JSON response with the breed" do
        put :update, params: {id: breed.id, breed: new_attributes}
        json_response = JSON.parse(response.body, symbolize_names: true)[:breed]
        expect(json_response[:name]).to eq new_attributes[:name]
        expect(response.status).to eq 200
      end
    end

    context "with invalid params" do
      let!(:existing_breed) { FactoryGirl.create(:breed) }

      it "renders a JSON response with errors for the breed" do
        put :update, params: {id: breed.id, breed: { name: existing_breed.name } }
        json_response = JSON.parse(response.body, symbolize_names: true)[:errors]
        expect(json_response[:name]).to include 'has already been taken'
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:breed) { FactoryGirl.create(:breed, :with_tag, tag_count: 1) }

    it "destroys the requested breed" do
      expect(Breed.count).to eq 1
      expect(BreedTagRecord.count).to eq 1
      delete :destroy, params: {id: breed.to_param}
      expect(Breed.count).to eq 0
      expect(BreedTagRecord.count).to eq 0
      expect(response.status).to eq 204
    end
  end

  describe "GET #tags" do
    let!(:breed) { FactoryGirl.create(:breed, :with_tag, tag_count: 2) }

    it 'returns the breed\'s tags' do
      get :get_tags, params: {id: breed.id}
      json_response = JSON.parse(response.body, symbolize_names: true)[:tags]
      expect(json_response.size).to eq 2
      expect(json_response.map { |tag| tag[:name] }).to match_array Tag.pluck(:name)
      expect(response.status).to eq 200
    end
  end

  describe "POST #tags" do
    let!(:breed) { FactoryGirl.create(:breed, :with_tag, tag_count: 2) }

    it 'returns the breed\'s tags' do
      post :post_tags, params: {id: breed.id, breed: { tags: ['Happy'] } }
      json_response = JSON.parse(response.body, symbolize_names: true)[:tags]
      expect(json_response.size).to eq 1
      expect(json_response.map { |tag| tag[:name] }).to match_array ['Happy']
      expect(response.status).to eq 201
    end
  end
end
