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

      it 'returns the error of missing encrypted_purchase' do
        expect(@error_sentences).to include('encrypted_purchase is missing')
      end
    end
  end
end
