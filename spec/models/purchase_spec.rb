require 'rails_helper'

RSpec.describe Purchase, :type => :model do
  describe 'should have the content' do
    let(:purchase) { FactoryGirl.create(:purchase) }

    context 'the total_price of the purchase' do
      it 'not null' do
        expect(purchase.total_price).not_to be_nil
      end
    end

    context 'the products of the purchase' do
      it 'not null' do
        expect(purchase.products).not_to be_nil
      end
    end

    context 'the products of the purchase' do
      it 'not null' do
        expect(purchase.products).not_to be_nil
      end
    end

    context 'the store_id of the purchase' do
      it 'not null' do
        expect(purchase.store_id).not_to be_nil
      end
    end
  end
end
