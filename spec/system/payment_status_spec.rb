# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PaymentStatus', type: :system do
  let(:user) { create(:user) }
  let(:payment) { create(:payment) }
  let(:order) { create(:order, user: user, payment: payment) }

  context 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_on 'Log in'
      visit admin_order_path(order)
    end

    it 'is allowed to see pending payment status on order page' do
      expect(payment).to have_state(:pending)
    end

    it "is allowed to change an order's payment status from 'pending' to 'failed'" do
      find('#payment').click_link('failed')
      payment.reload
      expect(payment).to have_state(:failed)
    end

    it "is allowed to change an order's payment status from 'pending' to 'completed'" do
      find('#payment').click_link('completed')
      payment.reload
      expect(payment).to have_state(:completed)
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

    it 'is not allowed to visit order page' do
      expect(page).to have_content('You are not authorized')
    end
  end

  context 'when guest visits app' do
    before do
      driven_by(:rack_test)
      visit admin_order_path(order)
    end

    it 'is not allowed to visit order page' do
      expect(page).to have_content('You are not authorized')
    end
  end
end
