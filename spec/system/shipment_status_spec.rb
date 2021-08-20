# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShipmentStatus', type: :system do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:shipment) { create(:shipment) }
  let!(:payment) { create(:payment) }
  let!(:order) { create(:order, user_id: user.id, payment_id: payment.id, shipment_id: shipment.id) }

  context 'when logged in as admin' do
    before do
      driven_by(:rack_test)
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    it 'admin sees pending shipment status on order page' do
      expect(page).to have_content('Shipment status: pending')
    end

    it "admin can change an order's shipment status from 'pending' to 'canceled'" do
      find('#shipment').click_link('canceled')
      expect(page).to have_content('Shipment status: canceled')
    end

    it "admin can change an order's shipment status from 'pending' to 'ready'" do
      find('#shipment').click_link('ready')
      expect(page).to have_content('Shipment status: ready')
    end

    it "admin can change an order's shipment status from 'ready' to 'failed'" do
      find('#shipment').click_link('ready')
      find('#shipment').click_link('failed')
      expect(page).to have_content('Shipment status: failed')
    end

    it "admin cannot change an order's shipment status from 'ready' to 'shipped' if payment status is not 'completed'" do
      find('#shipment').click_link('ready')
      expect(page).not_to have_content('shipped')
    end

    it "admin can change an order's shipment status from 'ready' to 'shipped' if payment status is 'completed'" do
      find('#payment').click_link('completed')
      find('#shipment').click_link('ready')
      find('#shipment').click_link('shipped')
      expect(page).to have_content('Shipment status: shipped')
    end
  end

  context 'when logged in as user' do
    before do
      driven_by(:rack_test)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    it 'user cannot visit order page' do
      expect(page).to have_content('You are not authorized')
    end
  end
end
