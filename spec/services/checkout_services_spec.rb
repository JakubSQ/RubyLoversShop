# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckoutServices, type: :model do
  let(:cart) { create(:cart) }
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:line_item) { create(:line_item) }

  it 'user checkouts an order' do
    CheckoutServices::Checkout.new(cart, user).call
    order = Order.last
    user = User.first
    expect(order.state).to eq('new')
    expect(order.user_id).to eq(user.id)
  end
end
