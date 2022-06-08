# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Saving address during checkout', type: :system do
  let!(:shipping_method) { create(:shipping_method) }
  let!(:product) { create(:product) }
  let(:address) { create(:address) }

  describe 'When logged in as user' do
    let(:user) { create(:user) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      sign_in user
      visit root_path
      click_on product.name
      click_button 'Add to cart'
      click_on 'Checkout'
    end

    context 'is allowed to' do
      it 'checkout an order' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        check 'order_billing_address_ship_to_bill'
        click_on 'Confirm checkout'
        click_on 'Confirm checkout'

        expect(page).to have_content('Order successfully created.')
        expect(Order.count).to eq(1)
      end
    end
  end

  describe 'When logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      Capybara.current_session.driver.header 'Referer', 'http://example.com'
      sign_in admin
      visit root_path
      click_on product.name
      click_button 'Add to cart'
    end

    context 'is not allowed' do
      it 'to checkout an order' do
        click_on 'Checkout'

        expect(page).to have_current_path('/users/sign_in')
      end
    end
  end

  describe 'Without logging in' do
    before do
      driven_by(:rack_test)
      visit root_path
      click_on product.name
      click_button 'Add to cart'
      click_on 'Checkout'
      visit new_order_path
    end

    context 'guest is allowed to' do
      let(:email) { 'email@example.com' }

      it 'checkout an order' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'user_email', with: email
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        check 'order_billing_address_ship_to_bill'
        click_on 'Confirm checkout'
        click_on 'Confirm checkout'

        expect(page).to have_content('Order successfully created.')
        expect(Order.count).to eq(1)
      end
    end
  end
end
