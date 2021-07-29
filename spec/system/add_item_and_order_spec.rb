# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe 'Adding Item/Order', type: :system do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }

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
        click_on 'Confirm checkout'
        expect(page).to have_content('Order successfully created')
      end
    end
  end
end
