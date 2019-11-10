class CarOffer < ApplicationRecord
  has_one_attached :photo

  validates_presence_of :title, :description, :price
end
