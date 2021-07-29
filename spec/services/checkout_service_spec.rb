# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutServices, type: :model do
  let!(:cart) { create(:cart) }
  let!(:user) { create(:user) }

  it 'product added to a cart' do
    order = Order.new
    CheckoutServices::Checkout.new.call(order, cart, user)
    expect(order.state).to eq 'new'
  end
end