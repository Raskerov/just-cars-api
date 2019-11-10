require 'rails_helper'

RSpec.describe 'CarOffers API', type: :request do
  let!(:car_offers) { create_list(:car_offer, 10) }
  let(:car_offer_id) { car_offers.first.id }

  # Test suite for GET /car_offers
  describe 'GET /api/v1/car_offers' do
    before { get '/api/v1/car_offers' }

    it 'returns car_offers' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /car_offers/:id
  describe 'GET /api/v1/car_offers/:id' do
    before { get "/api/v1/car_offers/#{car_offer_id}" }

    context 'when the record exists' do
      it 'returns the car offer' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(car_offer_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:car_offer_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find CarOffer with 'id'=100\"}")
      end
    end
  end

  # Test suite for POST /car_offers
  describe 'POST /api/v1/car_offers' do
    let(:valid_attributes) {
      {
        title: 'Audi S5',
        description: 'Audi A5 sport version',
        price: 50000.00
      }
    }

    context 'when the request is valid' do
      before { post '/api/v1/car_offers', params: valid_attributes }

      it 'creates a car offer' do
        expect(json['title']).to eq('Audi S5')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/car_offers', params: { title: 'Multipla', price: 0.00 } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Description can't be blank/)
      end
    end
  end
end
