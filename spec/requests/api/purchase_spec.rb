require 'rails_helper'

describe API do
  include Rack::Test::Methods

  describe 'Purchase' do
    let!(:without_params) { {} }

    context 'purchase products' do
      let(:response) do
        post '/api/v0/purchase', without_params
      end

      before { @error_sentences = JSON.load(response.body)['error'].split(', ') }

      it 'returns status 500' do
        expect(response.status).to eq(500)
      end

      it 'returns the error of missing beacon_id' do
        expect(@error_sentences).to include('beacon_id is missing')
      end

      it 'returns the error of missing token' do
        expect(@error_sentences).to include('token is missing')
      end

      it 'returns the error of missing purchase' do
        expect(@error_sentences).to include('products is missing')
      end

      it 'returns the error of missing purchase' do
        expect(@error_sentences).to include('total_price is missing')
      end
    end
  end
end
