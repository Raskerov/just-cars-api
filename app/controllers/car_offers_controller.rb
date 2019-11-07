class CarOffersController < ApplicationController
  before_action :set_car_offer, only: :show

  def index
    # TODO: Include photos
    car_offers = CarOffer.all
    render json: car_offers
  end

  def show
    # TODO: Include photo
    render json: @car_offer
  end

  def create
    # TODO: Attach photo
    @car_offer = CarOffer.create!(car_offer_params)
    render json: @car_offer
  end

  private

  def set_car_offer
    @car_offer = CarOffer.find(params[:id])
  end

  def car_offer_params
    params.permit(:title, :description, :price, :photo)
  end
end
