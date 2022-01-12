# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'

RSpec.describe 'LineItemQuantity', type: :system do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let(:user) { create(:user) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:selenium_chrome_headless)
      sign_in admin
      visit product_path(product)
      fill_in 'quantity', with: 1
      click_on 'Add to cart'
    end

    context 'is allowed to' do
      it 'change quantity of products to buy' do
        fill_in 'line_item_quantity', with: 20
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id).quantity).to eq(20)
      end

      it 'remove line item from cart by typing zero in quantity field' do
        fill_in 'line_item_quantity', with: 0
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end
    end

    context 'is not allowed to' do
      it 'type negative value in quantity field' do
        fill_in 'line_item_quantity', with: -1
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end

      it 'type string in quantity field' do
        fill_in 'line_item_quantity', with: 'xyz'
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end
    end
  end

  describe 'when logged in as user' do
    let(:user) { create(:user) }

    before do
      driven_by(:selenium_chrome_headless)
      sign_in user
      visit product_path(product)
      fill_in 'quantity', with: 1
      click_on 'Add to cart'
    end

    context 'is allowed to' do
      it 'change quantity of products to buy' do
        fill_in 'line_item_quantity', with: 20
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id).quantity).to eq(20)
      end

      it 'remove line item from cart by typing zero in quantity field' do
        fill_in 'line_item_quantity', with: 0
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end
    end

    context 'is not allowed to' do
      it 'type negative value in quantity field' do
        fill_in 'line_item_quantity', with: -1
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end

      it 'type string in quantity field' do
        fill_in 'line_item_quantity', with: 'xyz'
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end
    end
  end

  describe 'when guest visits app' do
    before do
      driven_by(:rack_test)
      visit product_path(product)
    end

    context 'is not allowed to' do
      it 'visit cart path' do
        fill_in 'quantity', with: 2
        click_on 'Add to cart'
        expect(page).to have_content('You are not authorized')
      end
    end
  end
end
