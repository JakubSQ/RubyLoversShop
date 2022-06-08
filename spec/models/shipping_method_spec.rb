# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShippingMethod, type: :model do
  describe 'validations' do
    subject(:shipping_method_valid) { shipping_method.valid? }

    describe 'name' do
      let(:shipping_method) { build(:shipping_method, name: name) }

      context 'when name is nil' do
        let(:name) { nil }

        it 'name validation fails' do
          expect(shipping_method_valid).to eq(false)
        end

        it 'raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:name]).to eq(['can\'t be blank'])
        end
      end

      context 'when name is present' do
        let(:name) { 'UPS' }

        it 'name valiadtion passes' do
          expect(shipping_method_valid).to eq(true)
        end

        it 'not raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:name]).to eq([])
        end
      end
    end

    describe 'price' do
      let(:shipping_method) { build(:shipping_method, price: price) }

      context 'when price is nil' do
        let(:price) { nil }

        it 'price validation fails' do
          expect(shipping_method_valid).to eq(false)
        end

        it 'raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:price]).to eq(['can\'t be blank', 'is not a number'])
        end
      end

      context 'when price is string' do
        let(:price) { 'ten' }

        it 'price validation fails' do
          expect(shipping_method_valid).to eq(false)
        end

        it 'raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:price]).to eq(['is not a number'])
        end
      end

      context 'when price is integer' do
        let(:price) { 10 }

        it 'price valiadtion passes' do
          expect(shipping_method_valid).to eq(true)
        end

        it 'not raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:price]).to eq([])
        end
      end
    end

    describe 'delivery time' do
      let(:shipping_method) { build(:shipping_method, delivery_time: delivery_time) }

      context 'when delivery time is nil' do
        let(:delivery_time) { nil }

        it 'delivery time validation fails' do
          expect(shipping_method_valid).to eq(false)
        end

        it 'raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:delivery_time]).to eq(['can\'t be blank', 'is not a number'])
        end
      end

      context 'when delivery time is string' do
        let(:delivery_time) { 'ten' }

        it 'delivery time validation fails' do
          expect(shipping_method_valid).to eq(false)
        end

        it 'raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:delivery_time]).to eq(['is not a number'])
        end
      end

      context 'when delivery time is integer' do
        let(:delivery_time) { 10 }

        it 'delivery time valiadtion passes' do
          expect(shipping_method_valid).to eq(true)
        end

        it 'not raise an error message' do
          shipping_method_valid
          expect(shipping_method.errors.messages[:delivery_time]).to eq([])
        end
      end
    end
  end
end
