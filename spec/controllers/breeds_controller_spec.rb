require 'rails_helper'

RSpec.describe BreedsController, type: :controller do
  let(:valid_attributes) { FactoryGirl.attributes_for(:breed) }

  let(:invalid_attributes) { }

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
    it "returns a success response" do
      breed = Breed.create! valid_attributes
      get :show, params: {id: breed.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Breed" do
        expect {
          post :create, params: {breed: valid_attributes}, session: valid_session
        }.to change(Breed, :count).by(1)
      end

      it "renders a JSON response with the new breed" do

        post :create, params: {breed: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(breed_url(Breed.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new breed" do

        post :create, params: {breed: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested breed" do
        breed = Breed.create! valid_attributes
        put :update, params: {id: breed.to_param, breed: new_attributes}, session: valid_session
        breed.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the breed" do
        breed = Breed.create! valid_attributes

        put :update, params: {id: breed.to_param, breed: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the breed" do
        breed = Breed.create! valid_attributes

        put :update, params: {id: breed.to_param, breed: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested breed" do
      breed = Breed.create! valid_attributes
      expect {
        delete :destroy, params: {id: breed.to_param}, session: valid_session
      }.to change(Breed, :count).by(-1)
    end
  end

end
