class BreedsController < ApplicationController
  before_action :set_breed, only: [:show, :update, :destroy, :get_tags, :post_tags]

  # GET /breeds
  def index
    @breeds = Breed.all

    render json: @breeds
  end

  # GET /breeds/1
  def show
    render json: @breed
  end

  # POST /breeds
  def create
    @breed = Breed.new(name: breed_params[:name])
    @breed.set_tags(breed_params[:tags])

    if @breed.save
      render json: @breed, status: 201, location: @breed
    else
      render json: { errors: @breed.errors }, status: 422
    end
  end

  # PATCH/PUT /breeds/1
  def update
    if @breed.set_tags(breed_params[:tags]) && @breed.update(name: breed_params[:name])
      render json: @breed
    else
      render json: { errors: @breed.errors }, status: 422
    end
  end

  # DELETE /breeds/1
  def destroy
    @breed.destroy
    head 204
  end

  # GET /breeds/1/tags
  def get_tags
    render json: { tags: @breed.tags }
  end

  # POST /breeds/1/tags
  def post_tags
    if @breed.set_tags(breed_params[:tags]) && @breed.save
      render json: { tags: @breed.tags }, status: 201
    else
      render json: { errors: @breed.errors }, status: 422
    end
  end

  # GET /breeds/stats
  def stats
    @breeds = Breed.all

    render json: @breeds, each_serializer: BreedStatsSerializer
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_breed
      @breed = Breed.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def breed_params
      params.require(:breed).permit(:name, tags: [])
    end
end
