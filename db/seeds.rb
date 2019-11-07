require 'uri'

5.times do
  car_offer = CarOffer.new(
    title: Faker::Vehicle.make_and_model,
    description: Faker::Lorem.sentence(word_count: 30),
    price: Faker::Number.number(digits: 5),
  )
  photo_file = URI.open('https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg')
  car_offer.photo.attach(io: photo_file, filename: 'car-photo.jpeg')
  car_offer.save!
  puts "Car offer saved!"
end
