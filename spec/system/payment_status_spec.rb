# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentStatus', type: :system do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:payment) { create(:payment) }
  let(:order) { create(:order, user_id: user.id, payment_id: payment.id) }

  context 'when logged in as admin' do
    before do
      driven_by(:rack_test)
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    it 'admin sees pending payment status on order page' do
      expect(page).to have_content('pending')
    end

    it "admin can change an order's payment status from 'pending' to 'failed'" do
      find('#payment').click_link('failed')
      expect(page).to have_content('Payment status: failed')
    end

    it "admin can change an order's payment status from 'pending' to 'completed'" do
      find('#payment').click_link('completed')
      expect(page).to have_content('Payment status: completed')
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
