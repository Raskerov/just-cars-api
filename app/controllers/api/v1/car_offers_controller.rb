class Api::V1::CarOffersController < ApplicationController
  before_action :set_car_offer, only: :show

  def index
    # TODO: Handle pagination and searching
    car_offers = CarOffer.all
    json_response(car_offers)
  end

  def show
    json_response(@car_offer)
  end

  def create
    car_offer = CarOffer.new(car_offer_params)
    if params[:photo].present?
      car_offer.photo.attach(io: car_offer_photo_path, filename: car_offer_photo_name)
    end
    if car_offer.save!
      json_response(car_offer)
    else
      json_response(car_offer.errors, status: :unprocessable_entity)
    end
  end

  private

  def set_car_offer
    @car_offer = CarOffer.find(params[:id])
  end

  def car_offer_params
    params.permit(:title, :description, :price, :photo)
  end

  def car_offer_photo_path
    uri = URI.parse(params[:photo])
    file = Net::HTTP.get_response(uri).body
    StringIO.new(file)
  end

  def car_offer_photo_name
    File.basename(URI.parse(params[:photo]).path)
  end
end
