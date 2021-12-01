# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }

  it 'user checkouts an order' do
    a = Checkout::Creator.new.call(cart, user, address)
    expect(a.payload.state).to eq('new')
    expect(a.payload.user_id).to eq(user.id)
  end
end
