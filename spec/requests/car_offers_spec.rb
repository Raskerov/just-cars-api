require 'rails_helper'

RSpec.describe 'CarOffers API', type: :request do
  let!(:car_offers) { create_list(:car_offer, 15) }
  let(:car_offer_id) { car_offers.first.id }
  let(:valid_attributes) {
    {
      title: 'Audi S5',
      description: 'Audi A5 sport version',
      price: 50000.00
    }
  }

  # Test suite for GET /car_offers
  describe 'GET /api/v1/car_offers' do
    context 'without filters' do
      context 'without specific params' do
        before { get '/api/v1/car_offers' }

        it 'returns car_offers' do
          expect(json).not_to be_empty
          expect(json['objects'].size).to eq(10)
          expect(json).to include('meta')
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'get second page' do
        before { get '/api/v1/car_offers?page=2' }

        it 'returns car_offers' do
          expect(json).not_to be_empty
          expect(json['objects'].size).to eq(5)
          expect(json).to include('meta')
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'with filters' do
      before { create_filter_car }

      context 'title filter' do
        context 'with existing record' do
          before { get '/api/v1/car_offers?in_title=Filtered' }

          it 'returns filtered car offer' do
            expect(json['objects']).not_to be_empty
            expect(json['objects'].first['title']).to eq('Filtered car')
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'with non-existing record' do
          before { get '/api/v1/car_offers?in_title=Notexisting' }

          it 'returns the car offer' do
            expect(json['objects']).to be_empty
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end
      end

      context 'description filter' do
        context 'with existing record' do
          before { get '/api/v1/car_offers?in_desc=carfolio' }

          it 'returns filtered car offer' do
            expect(json['objects']).not_to be_empty
            expect(json['objects'].first['title']).to eq('Filtered car')
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'with non-existing record' do
          before { get '/api/v1/car_offers?in_desc=Notexisting' }

          it 'returns the car offer' do
            expect(json['objects']).to be_empty
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end
      end

      context 'min price filter' do
        context 'with existing record' do
          before { get '/api/v1/car_offers?min_price=49999' }

          it 'returns filtered car offer' do
            expect(json['objects']).not_to be_empty
            expect(json['objects'].first['title']).to eq('Filtered car')
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'with non-existing record' do
          before { get '/api/v1/car_offers?min_price=60000' }

          it 'returns the car offer' do
            expect(json['objects']).to be_empty
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end
      end

      context 'max price filter' do
        context 'with existing record' do
          # Add min price to eliminate factories
          before { get '/api/v1/car_offers?min_price=10000&max_price=60000' }

          it 'returns filtered car offer' do
            expect(json['objects']).not_to be_empty
            expect(json['objects'].first['title']).to eq('Filtered car')
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end

        context 'with non-existing record' do
          # Add min price to eliminate factories
          before { get '/api/v1/car_offers?min_price=10000&max_price=49999' }

          it 'returns the car offer' do
            expect(json['objects']).to be_empty
          end

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end
      end
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

  private

  def create_filter_car
    CarOffer.create!(
      title: 'Filtered car',
      description: 'Filtered description, search query is carfolio',
      price: 50000.00)
  end
end
