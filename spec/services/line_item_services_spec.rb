# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItemServices, type: :model do
  let!(:product) { create(:product) }
  let!(:cart) { create(:cart) }
  let!(:line_item) { create(:line_item, cart_id: cart.id, product_id: product.id) }

  it 'product remove from cart' do
    LineItemServices::DeleteLineItem.new.call(cart, line_item)
    expect(cart.line_items.count).to eq(0)
  end
end
