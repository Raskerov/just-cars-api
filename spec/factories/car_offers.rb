FactoryBot.define do
  factory :car_offer do
    title { Faker::Vehicle.make_and_model }
    description { Faker::Lorem.sentence(word_count: 30) }
    price { Faker::Number.number(digits: 4) }
  end
end
