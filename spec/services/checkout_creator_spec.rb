# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:product) { create(:product) }
  let!(:line_item) { create(:line_item) }

  it 'user checkouts an order' do
    Checkout::Creator.new.call(cart, user, address)
    order = Order.last
    user = User.first
    expect(order.state).to eq('new')
    expect(order.user_id).to eq(user.id)
  end

  it 'admin checkouts an order' do
    Checkout::Creator.new.call(cart, admin, address)
    order = Order.last
    admin = Admin.first
    expect(order.state).to eq('new')
    expect(order.admin_id).to eq(admin.id)
  end
end
