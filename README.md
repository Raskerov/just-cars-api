# README

Simple API only app.

This api servers car offers that has:
* Title
* Description
* Price
* Photo

* Ruby version
  - 2.6.3

* How to run the test suite
  - bundle exec rspec

* How to run locally
  - git clone
  - bundle install
  - create and seed database
  - start rails server

  Everything is served under endpoints:
  - GET /api/v1/car_offers
  - POST /api/v1/car_offers
  - GET /api/v1/car_offers/#{id}
