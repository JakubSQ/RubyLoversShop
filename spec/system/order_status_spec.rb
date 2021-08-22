# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderStatus', type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:shipment) { create(:shipment) }
  let(:payment) { create(:payment) }
  let(:order) { create(:order, user_id: user.id, payment_id: payment.id, shipment_id: shipment.id) }

  describe 'when logged in as admin' do
    before do
      driven_by(:rack_test)
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    context 'you have permission to' do
      it 'see new order status on order page' do
        expect(page).to have_content('Order Status: new')
      end

      it "change an order status from 'new' to 'failed'" do
        find('#order').click_link('failed')
        expect(page).to have_content('Order Status: failed')
      end
    end

    context "you have permission to change order status to 'completed' only if" do
      it "shipment status is 'shipped' and payment status is 'completed'" do
        find('#payment').click_link('completed')
        find('#shipment').click_link('ready')
        find('#shipment').click_link('shipped')
        find('#order').click_link('completed')
        expect(page).to have_content('Order Status: completed')
      end
    end

    context "you don't have permission to change order status to 'completed' if" do
      it "shipment status isn't 'shipped' and payment status isn't 'completed'" do
        find('#shipment').click_link('ready')
        expect(page).to have_content('Payment status: pending')
        expect(page).to have_no_css('#order', text: 'completed')
      end

      it "shipment status isn't 'shipped' and payment status is 'completed'" do
        find('#shipment').click_link('ready')
        find('#payment').click_link('completed')
        expect(page).to have_no_css('#order', text: 'completed')
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

    it 'user cannot visit order page' do
      expect(page).to have_content('You are not authorized')
    end
  end
end
