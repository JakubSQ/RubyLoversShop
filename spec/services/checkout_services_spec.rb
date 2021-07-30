# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutServices, type: :model do
  let!(:cart) { create(:cart) }
  let!(:user) { create(:user) }

  it 'user checkouts an order' do
    CheckoutServices::Checkout.new.call(cart, user)
    order = Order.last
    expect(order.state).to eq('new')
    expect(order.user_id).to eq(user.id)
  end
end
