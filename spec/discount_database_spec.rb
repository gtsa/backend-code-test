require 'spec_helper'
require 'discount_database'

RSpec.describe DiscountDatabase do
  subject(:discount_database) { described_class.new }

  describe '#get_discount_type' do
    it 'returns the correct discount type for apple' do
      expect(discount_database.get_discount_type(:apple)).to eq(:buy_one_get_one_free)
    end

    it 'returns the correct discount type for banana' do
      expect(discount_database.get_discount_type(:banana)).to eq(:half_price)
    end

    it "returns 'no discount' for an item without discount" do
      expect(discount_database.get_discount_type(:orange)).to eq(:no_discount)
    end
  end

  describe '#calculate_price' do
    let(:price) { 10 }

    context 'when discount type is buy_one_get_one_free' do
      it "applies 'buy one - get one free' discount correctly" do
        expect(discount_database.calculate_price(price, 4, :buy_one_get_one_free)).to eq(20)
      end
    end

    context 'when discount type is buy_three_get_one_free' do
      it "applies 'buy three - get one free' discount correctly" do
        expect(discount_database.calculate_price(price, 4, :buy_three_get_one_free)).to eq(30)
      end
    end

    context 'when discount type is half_price' do
      it "applies 'half price' discount correctly" do
        expect(discount_database.calculate_price(price, 3, :half_price)).to eq(15)
      end
    end

    context 'when discount type is first_item_half_price' do
      it "applies 'first item half price' discount correctly" do
        expect(discount_database.calculate_price(price, 2, :first_item_half_price)).to eq(15)
      end
    end

    context 'when discount type is no_discount' do
      it 'applies the total price without discount' do
        expect(discount_database.calculate_price(price, 3, :no_discount)).to eq(30)
      end
    end
  end
end
