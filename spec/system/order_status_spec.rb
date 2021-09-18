# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderStatus', type: :system do
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

    context 'is allowed to' do
      it 'see new order status on order page' do
        expect(order).to have_state(:new)
      end

      it "change an order status from 'new' to 'failed'" do
        find('#order').click_link('failed')
        order.reload
        expect(order).to have_state(:failed)
      end
    end

    context "when shipment status is 'shipped' and payment status is 'completed'" do
      it "is allowed to change order status to 'completed'" do
        find('#payment').click_link('completed')
        find('#shipment').click_link('ready')
        find('#shipment').click_link('shipped')
        find('#order').click_link('completed')
        order.reload
        expect(order).to have_state(:completed)
      end
    end

    context "when shipment status isn't 'shipped' and payment status isn't 'completed'" do
      it "is not allowed to change order status to 'completed'" do
        find('#shipment').click_link('ready')
        shipment.reload
        expect(order).not_to allow_event :done
      end
    end

    context "when shipment status isn't 'shipped' and payment status is 'completed'" do
      it "is not allowed to change order status to 'completed'" do
        find('#shipment').click_link('ready')
        find('#payment').click_link('completed')
        shipment.reload
        payment.reload
        expect(order).not_to allow_event :done
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
