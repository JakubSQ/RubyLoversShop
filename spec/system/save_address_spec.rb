# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Saving address during checkout', type: :system do
  let!(:product) { create(:product) }
  let(:address) { create(:address) }

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

    context 'is allowed to' do
      it 'save address during checkout' do
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        check 'order_billing_address_ship_to_bill'
        check 'save_address'
        click_on 'Confirm checkout'
        expect(user.addresses.count).to eq(1)
      end
    end
  end

  describe 'When logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      sign_in admin
      visit root_path
      click_on product.name
      click_button 'Add to cart'
    end

    context 'is not allowed to checkout' do
      it 'with two seperate addresses' do
        click_on 'Checkout'
        expect(page).to have_content('Admin cannot checkout order')
      end
    end
  end

  describe 'Without logging in' do
    before do
      driven_by(:rack_test)
      visit root_path
      click_on product.name
    end

    context 'guest is not allowed to checkout' do
      it 'with two seperate addresses' do
        click_button 'Add to cart'
        expect(page).to have_content('You are not authorized')
      end
    end
  end
end