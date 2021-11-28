# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe 'Adding Item/Order', type: :system do
  let(:user) { create(:user) }
  let!(:product) { create(:product) }
  let(:address) { create(:address) }

  describe 'Item/Orders actions' do
    before do
      driven_by(:rack_test)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on 'Log in'
    end

    context 'Adding item to cart' do
      it 'from homepage' do
        visit root_path
        click_on product.name
        click_button 'Add to cart'
        expect(page).to have_content('Item added to cart')
        expect(page).to have_content(product.name)
      end

      it 'from /products' do
        visit products_path
        click_on product.name
        click_button 'Add to cart'
        expect(page).to have_content('Item added to cart')
        expect(page).to have_content(product.name)
      end
    end

    context 'Checking out' do
      it "user's order list" do
        visit root_path
        click_on product.name
        click_button 'Add to cart'
        click_on 'Checkout'
        fill_in 'order_billing_address_name', with: address.name
        fill_in 'order_billing_address_street_name1', with: address.street_name1
        fill_in 'order_billing_address_city', with: address.city
        fill_in 'order_billing_address_country', with: address.country
        fill_in 'order_billing_address_state', with: address.state
        fill_in 'order_billing_address_zip', with: address.zip
        fill_in 'order_billing_address_phone', with: address.phone
        click_on 'Confirm checkout'
        expect(page).to have_content('Order successfully created')
      end
    end
  end
end
