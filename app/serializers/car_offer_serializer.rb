class CarOfferSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :price, :car_photo_url

  def car_photo_url
    return unless object.photo.present?
    variant = object.photo.variant(resize: "800x600")
    rails_representation_url(variant, only_path: true)
  end
end
