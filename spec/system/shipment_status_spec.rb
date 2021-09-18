# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShipmentStatus', type: :system do
  let(:user) { create(:user) }
  let(:shipment) { create(:shipment) }
  let(:payment) { create(:payment) }
  let(:order) { create(:order, user: user, payment: payment, shipment: shipment) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
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
