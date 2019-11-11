class CarOffer < ApplicationRecord
  has_one_attached :photo

  validates_presence_of :title, :description, :price

  paginates_per 10

  scope :in_title, ->(query) { where('title LIKE ?', '%' + query + '%') }
  scope :in_desc, ->(query) { where('description LIKE ?', '%' + query + '%') }
  scope :min_price, ->(query) { where('price > ?', query) }
  scope :max_price, ->(query) { where('price < ?', query) }
end
