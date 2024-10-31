require 'spec_helper'
require 'checkout'
require 'discount_database'

RSpec.describe Checkout do
  describe '#total' do
    subject(:total) { checkout.total }

    let(:checkout) { Checkout.new(pricing_rules) }
    let(:pricing_rules) {
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200
      }
    }

    context 'when no offers apply' do
      before do
        checkout.scan(:apple)
        checkout.scan(:orange)
      end

      it 'returns the base price for the basket' do
        expect(total).to eq(30)
      end
    end

    context 'when a buy one get one free discount applies on apples' do
      before do
        checkout.scan(:apple)
        checkout.scan(:apple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(10)
      end

      context 'and there is an odd number of apples' do
        before do
          checkout.scan(:apple)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(20)
        end
      end

      context 'and there are other items' do
        before do
          checkout.scan(:orange)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a buy one get one free discount applies on pears' do
      before do
        checkout.scan(:pear)
        checkout.scan(:pear)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end

      context 'and there are other discounted items' do
        before do
          checkout.scan(:banana)
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a half price offer applies on bananas' do
      before do
        checkout.scan(:banana)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end
    end

    context 'when a first-item half-price discount applies on pineapples' do
      before do
        checkout.scan(:pineapple)
        checkout.scan(:pineapple)
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(150)
      end
    end

    context 'when a buy three get one free discount applies on mangos' do
      before do
        4.times { checkout.scan(:mango) }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(600)
      end
    end

    context 'when a combination of all different fruits in different quantities' do
      before do
        4.times { checkout.scan(:apple) }
        4.times { checkout.scan(:orange) }
        4.times { checkout.scan(:pear) }
        7.times { checkout.scan(:banana) }
        2.times { checkout.scan(:pineapple) }
        1.times { checkout.scan(:mango) }
      end

      it 'returns the correct total for the basket' do
        expect(checkout.total).to eq(585)
      end
    end

    context 'when calculating total without scanning any items' do
      it 'returns a total of zero' do
        expect(total).to eq(0.00)
      end
    end
  end
end
