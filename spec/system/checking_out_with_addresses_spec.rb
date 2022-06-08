# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Adding addresses to checkout', type: :system do
  let!(:shipping_method) { create(:shipping_method) }
  let!(:product) { create(:product) }
  let(:address) { create(:address) }
  let(:address1) { create(:address) }

  describe 'When logged in as user' do
    let(:user) { create(:user) }

    before do
      driven_by(:rack_test)
      sign_in user
      visit root_path
      click_on product.name
      click_button 'Add to cart'
      click_on 'Checkout'
    end

    context 'is allowed to checkout' do
      it 'with two seperate addresses' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        fill_in 'order_shipping_address_name', with: address1.name
        fill_in 'order_shipping_address_street_name1', with: address1.street_name1
        fill_in 'order_shipping_address_city', with: address1.city
        fill_in 'order_shipping_address_country', with: address1.country
        fill_in 'order_shipping_address_state', with: address1.state
        fill_in 'order_shipping_address_zip', with: address1.zip
        fill_in 'order_shipping_address_phone', with: address1.phone
        click_on 'Confirm checkout'
        click_on 'Confirm checkout'
        expect(page).to have_content('Order successfully created')
      end

      it 'with billing_address and checked checkbox' do
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
        expect(page).to have_content('Order successfully created')
      end
    end

    context 'is not allowed to checkout' do
      it 'with only one address and unchecked checkbox' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        click_on 'Confirm checkout'
        expect(page).not_to have_content('Order successfully created')
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

    context 'is not allowed to checkout' do
      it 'with two seperate addresses' do
        click_on 'Checkout'
        expect(page).to have_current_path('/users/sign_in')
      end
    end
  end

  describe 'Without logging in' do
    let(:email) { 'email@example.com' }

    before do
      driven_by(:rack_test)
      visit root_path
      click_on product.name
      click_button 'Add to cart'
      click_on 'Checkout'
      visit new_order_path
    end

    context 'is allowed to checkout' do
      it 'with email and two seperate addresses' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'user_email', with: email
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        fill_in 'order_shipping_address_name', with: address1.name
        fill_in 'order_shipping_address_street_name1', with: address1.street_name1
        fill_in 'order_shipping_address_city', with: address1.city
        fill_in 'order_shipping_address_country', with: address1.country
        fill_in 'order_shipping_address_state', with: address1.state
        fill_in 'order_shipping_address_zip', with: address1.zip
        fill_in 'order_shipping_address_phone', with: address1.phone
        click_on 'Confirm checkout'
        click_on 'Confirm checkout'
        expect(page).to have_content('Order successfully created')
      end

      it 'with email and billing_address and checked checkbox' do
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
        expect(page).to have_content('Order successfully created')
      end
    end

    context 'is not allowed to checkout' do
      it 'with email and only one address and unchecked checkbox' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'user_email', with: email
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        click_on 'Confirm checkout'
        expect(page).not_to have_content('Order successfully created')
      end

      it 'without email address' do
        select shipping_method.shipping_method_info, from: 'shipment_shipment_id'
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        click_on 'Confirm checkout'
        expect(page).not_to have_content('Order successfully created')
      end
    end
  end
end
