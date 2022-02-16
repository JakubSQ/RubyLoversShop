# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShippingMethodCRUD', type: :system do
  context 'when logged in as an admin' do
    let(:shipping_method) { build(:shipping_method) }
    let!(:existing_shipping_method) { create(:shipping_method) }
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      sign_in admin
      visit admin_root_path
      click_on 'Shipping methods'
    end

    it 'is allowed to add new shipping method' do
      click_on 'Add new shipping method'
      fill_in 'shipping_method_name', with: shipping_method.name
      fill_in 'shipping_method_price', with: shipping_method.price
      fill_in 'shipping_method_delivery_time', with: shipping_method.delivery_time
      click_button 'Create Shipping method'

      expect(page).to have_content('Shipping method created successfully')
      expect(page).to have_content(shipping_method.name)
    end

    it 'is allowed to update shipping method' do
      click_on 'Edit'
      fill_in 'shipping_method_name', with: 'new name'
      click_button 'Update Shipping method'

      expect(page).to have_content('Shipping method updated successfully')
      expect(page).to have_content('new name')
    end

    it 'is allowed to delete shipping method' do
      click_on 'Delete'

      expect(page).to have_content('Shipping method destroyed successfully')
      expect(page).not_to have_content(existing_shipping_method.name)
    end
  end

  context 'when logged in as an user' do
    let(:user) { create(:user) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      sign_in user
      visit admin_root_path
    end

    it 'is not allowed to get admin panel' do
      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(page).to have_content('You are not authorized')
    end
  end

  context 'without logging in' do
    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      visit admin_root_path
    end

    it 'is not allowed to get admin panel' do
      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(page).to have_content('You are not authorized')
    end
  end
end
