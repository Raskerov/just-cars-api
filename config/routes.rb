Rails.application.routes.draw do
  resources :car_offers, only: %w[index show create]
end
