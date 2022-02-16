# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShippingMethodCRUD', type: :system do
  context 'when logged in as an user' do
    let!(:shipping_method1) { create(:shipping_method) }
    let!(:shipping_method2) { create(:shipping_method, active: false) }
    let(:user) { create(:user) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      sign_in user
      visit '/orders/new'
    end

    it 'is allowed to see only active shipping methods' do
      expect(page).to have_content(shipping_method1.shipping_method_info)
      expect(page).not_to have_content(shipping_method2.shipping_method_info)
    end
  end

  context 'without logging in' do
    let!(:shipping_method1) { create(:shipping_method) }
    let!(:shipping_method2) { create(:shipping_method, active: false) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      visit '/orders/new'
    end

    it 'guest is allowed to see only active shipping methods' do
      expect(page).to have_content(shipping_method1.shipping_method_info)
      expect(page).not_to have_content(shipping_method2.shipping_method_info)
    end
  end

  context 'when logged in as an admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      sign_in admin
      visit '/orders/new'
    end

    it 'is not allowed to get to checkout' do
      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(page).to have_content('Admin cannot checkout order')
    end
  end
end
