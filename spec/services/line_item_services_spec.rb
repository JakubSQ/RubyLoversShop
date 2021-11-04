# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItemServices, type: :model do
  let!(:product) { create(:product) }
  let!(:product1) { create(:product, name: 'trousers') }
  let!(:cart) { Cart.create }
  let!(:line_item) { LineItem.create(cart_id: cart.id, product_id: product.id, quantity: 10) }
  let!(:line_item1) { LineItem.create(cart_id: cart.id, product_id: product1.id, quantity: 10) }

  context 'shopping cart includes two products' do
    it 'one product having 10 instances remove from cart' do
      subject = LineItemServices::DeleteLineItem.new.call(cart, line_item)

      expect(cart.line_items.count).to eq(1)
      expect(subject.payload).to eq('Line Item successfully removed from shopping cart')
    end

    it 'two products having 10 instances remove from cart' do
      LineItemServices::DeleteLineItem.new.call(cart, line_item)
      subject = LineItemServices::DeleteLineItem.new.call(cart, line_item1)

      expect(cart.line_items.count).to eq(0)
      expect(subject.payload).to eq('Your shopping cart is empty')
    end
  end
end
