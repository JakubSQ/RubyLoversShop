# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPage', type: :system do
  let(:address) { create(:address) }
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product) }
  let!(:payment) { create(:payment) }
  let!(:line_item) do
    create(:line_item, cart_id: cart.id,
                       product_id: product.id,
                       order_id: order.id)
  end
  let(:order) do
    create(:order, user_id: user.id,
                   payment_id: payment.id,
                   billing_address_id: address.id,
                   shipping_address_id: address.id)
  end

  before do
    driven_by(:rack_test)
    Capybara.current_session.driver.header 'Referer', 'http://example.com'
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
  end
end
