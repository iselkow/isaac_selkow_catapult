require 'rails_helper'
RSpec.describe TagsController, type: :controller do
  let(:valid_attributes) { { name: FFaker::Music.artist } }

  describe "GET #index" do
    before do
      3.times { FactoryGirl.create(:tag) }
      get :index
    end

    it "returns an array of tags" do
      json_response = JSON.parse(response.body, symbolize_names: true)[:tags]
      expect(json_response.count).to eq 3
      expect(json_response.first[:name]).to eq Tag.first.name
      expect(response.status).to eq 200
    end
  end

  describe "GET #show" do
    let(:tag) { FactoryGirl.create(:tag) }

    it "returns a tag" do
      get :show, params: { id: tag.id }
      json_response = JSON.parse(response.body, symbolize_names: true)[:tag]
      expect(json_response[:name]).to eq tag.name
      expect(response.status).to eq 200
    end
  end

  describe "PUT #update" do
    let!(:tag) { FactoryGirl.create(:tag) }

    context "with valid params" do
      let(:new_attributes) { { name: FFaker::Name.name } }

      it "updates the requested tag" do
        put :update, params: {id: tag.id, tag: new_attributes}
        tag.reload
        expect(tag.name).to eq new_attributes[:name]
      end

      it "renders a JSON response with the tag" do
        put :update, params: {id: tag.id, tag: new_attributes}
        json_response = JSON.parse(response.body, symbolize_names: true)[:tag]
        expect(json_response[:name]).to eq new_attributes[:name]
        expect(response.status).to eq 200
      end
    end

    context "with invalid params" do
      let!(:existing_tag) { FactoryGirl.create(:tag) }

      it "renders a JSON response with errors for the tag" do
        put :update, params: {id: tag.id, tag: { name: existing_tag.name } }
        json_response = JSON.parse(response.body, symbolize_names: true)[:errors]
        expect(json_response[:name]).to include 'has already been taken'
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:tag) { FactoryGirl.create(:tag, :with_breed, breed_count: 1) }

    it "destroys the requested tag" do
      expect(Tag.count).to eq 1
      expect(BreedTagRecord.count).to eq 1
      delete :destroy, params: {id: tag.to_param}
      expect(Tag.count).to eq 0
      expect(BreedTagRecord.count).to eq 0
      expect(response.status).to eq 204
    end
  end

  describe "GET #stats" do
    before do
      2.times { FactoryGirl.create(:tag, :with_breed, breed_count: 3) }
    end

    it 'returns the stats of all tags and a list of their breed_ids' do
      get :stats
      json_response = JSON.parse(response.body, symbolize_names: true)[:tags]
      expect(json_response.size).to eq 2

      first_response = json_response.first
      tag = Tag.first
      expect(first_response[:id]).to eq tag.id
      expect(first_response[:name]).to eq tag.name
      expect(first_response[:breed_count]).to eq 3
      expect(first_response[:breed_ids]).to eq tag.breeds.pluck(:id)
    end
  end
end
