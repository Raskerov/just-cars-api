class Api::V1::CarOffersController < ApplicationController
  before_action :set_car_offer, only: :show
  before_action :filter_car_offers, only: :index

  def index
    objects_to_display = @car_offers.page(params[:page] ? params[:page].to_i : 1)
    json_response(objects: objects_to_display, meta: pagination_meta(objects_to_display))
  end

  def show
    json_response(@car_offer)
  end

  def create
    car_offer = CarOffer.new(car_offer_params)
    if params[:photo].present?
      car_offer.photo.attach(io: offer_photo_path, filename: offer_photo_name)
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

  def offer_photo_path
    uri = URI.parse(params[:photo])
    file = Net::HTTP.get_response(uri).body
    StringIO.new(file)
  end

  def offer_photo_name
    File.basename(URI.parse(params[:photo]).path)
  end

  def filter_car_offers
    offers = CarOffer.all
    offers = offers.in_title(params[:in_title]) if params[:in_title].present?
    offers = offers.in_desc(params[:in_desc]) if params[:in_desc].present?
    offers = offers.min_price(params[:min_price]) if params[:min_price].present?
    offers = offers.max_price(params[:max_price]) if params[:max_price].present?
    @car_offers = offers
  end

  def pagination_meta(object)
    { current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count }
  end
end
