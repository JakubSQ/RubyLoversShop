# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShipmentStatus', type: :system do
  let(:user) { create(:user) }
  let(:address) { create(:address) }
  let(:payment) { create(:payment) }
  let!(:shipment) { create(:shipment, shipping_method_id: shipping_method.id) }
  let!(:shipping_method) { create(:shipping_method) }
  let!(:order) do
    create(:order, user_id: user.id,
                   email: user.email,
                   payment_id: payment.id,
                   shipment_id: shipment.id,
                   billing_address_id: address.id,
                   shipping_address_id: address.id)
  end

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    context 'it is allowed to' do
      it 'see pending shipment status on order page' do
        expect(shipment).to have_state(:pending)
      end

      it "change an order's shipment status from 'pending' to 'canceled'" do
        find('#shipment').click_link('canceled')
        shipment.reload
        expect(shipment).to have_state(:canceled)
      end

      it "change an order's shipment status from 'pending' to 'ready'" do
        find('#shipment').click_link('ready')
        shipment.reload
        expect(shipment).to have_state(:ready)
      end

      it "change an order's shipment status from 'ready' to 'failed'" do
        find('#shipment').click_link('ready')
        find('#shipment').click_link('failed')
        shipment.reload
        expect(shipment).to have_state(:failed)
      end

      it "change an order's shipment status from 'ready' to 'shipped' if payment status is 'completed'" do
        find('#payment').click_link('completed')
        find('#shipment').click_link('ready')
        find('#shipment').click_link('shipped')
        payment.reload
        shipment.reload
        expect(shipment).to have_state(:shipped)
      end
    end

    context 'it is not allowed to' do
      it "change an order's shipment status from 'ready' to 'shipped' if payment status is not 'completed'" do
        find('#shipment').click_link('ready')
        shipment.reload
        expect(shipment).not_to allow_event :delivered
      end
    end
  end

  describe 'when logged in as user' do
    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    it 'is not allowed to visit order page' do
      expect(page).to have_content('You are not authorized')
    end
  end

  describe 'when guest visits app' do
    before do
      driven_by(:rack_test)
      visit admin_order_path(order)
    end

    it 'is not allowed to visit order page' do
      expect(page).to have_content('You are not authorized')
    end
  end
end
