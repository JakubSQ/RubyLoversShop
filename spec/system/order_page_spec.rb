# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPage', type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let!(:cart) { Cart.create }
  let!(:product) { create(:product) }
  let!(:line_item) { LineItem.create(cart_id: cart.id, product_id: product.id, order_id: order.id) }
  let(:order) { Order.create(user_id: user.id) }

  before do
    driven_by(:rack_test)
    visit new_admin_session_path
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: admin.password
    click_on 'Log in'
    visit admin_order_path(order)
  end

  it "admin sees Order's detailed information" do
    expect(page).to have_content(order.id)
    expect(page).to have_content(order.user_email)
    expect(page).to have_content(order.user_id)
    expect(page).to have_content(order.line_items.first.product.name)
    expect(page).to have_content(order.line_items.first.product.prize)
  end
end