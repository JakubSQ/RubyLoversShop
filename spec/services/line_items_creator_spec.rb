# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItems, type: :model do
  let!(:product) { create(:product) }
  let!(:product1) { create(:product, name: 'trousers') }
  let!(:cart) { Cart.create }

  context 'adding' do
    it 'one product to cart' do
      LineItems::Creator.new.call(cart, product, 1)

      expect(cart.line_items.count).to eq(1)
    end

    it 'twice the same product to cart' do
      2.times do
        LineItems::Creator.new.call(cart, product, 1)
      end

      expect(cart.line_items.count).to eq(1)
      expect(cart.line_items.first.quantity).to eq(2)
    end

    it 'two different products to cart' do
      LineItems::Creator.new.call(cart, product, 1)
      LineItems::Creator.new.call(cart, product1, 1)

      expect(cart.line_items.count).to eq(2)
    end
  end
end
