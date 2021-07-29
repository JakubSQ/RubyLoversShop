# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartServices, type: :model do
  let!(:product) { create(:product) }
  let!(:cart) { create(:cart) }

  it 'product added to a cart' do
    CartServices::AddProduct.new.call(cart, product)
    expect(cart.line_items.count).to eq 1
  end
end