class CarOffer < ApplicationRecord
  has_one_attached :photo

  validates_presence_of :title, :description, :price

  paginates_per 10
end
