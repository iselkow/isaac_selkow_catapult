class BreedsController < ApplicationController
  before_action :set_breed, only: [:show, :update, :destroy]

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
    @breed = Breed.new(breed_params)

    if @breed.save
      render json: @breed, status: 201, location: @breed
    else
      render json: { errors: @breed.errors }, status: 422
    end
  end

  # PATCH/PUT /breeds/1
  def update
    if @breed.update(breed_params)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_breed
      @breed = Breed.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def breed_params
      params.require(:breed).permit(:name)
    end
end
