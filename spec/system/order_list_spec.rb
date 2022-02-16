# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrdersList', type: :system do
  let(:address) { create(:address) }
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:payment) { create(:payment) }
  let!(:order) do
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
    visit admin_root_path
  end

  it 'admin sees Orders link on navigation bar' do
    expect(page).to have_content('Orders')
  end

  it 'admin sees order list in Order page' do
    click_on 'Orders'
    expect(page).to have_content(order.id)
  end

  it 'admin sees pagination in Orders page' do
    click_on 'Orders'
    expect(page).to have_content('Next')
    expect(page).to have_content('Prev')
  end
end
