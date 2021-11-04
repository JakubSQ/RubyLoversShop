# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LineItemQuantity', type: :system do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:selenium_chrome_headless)
      visit new_admin_session_path
      fill_in 'admin_email', with: admin.email
      fill_in 'admin_password', with: admin.password
      click_on 'Log in'
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
        expect(page).to have_content('Please, type positive value.')
        expect(LineItem.find_by(product_id: product.id).quantity).not_to eq(-1)
      end

      it 'type string in quantity field' do
        fill_in 'line_item_quantity', with: 'xyz'
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id).quantity).not_to eq('xyz')
      end
    end
  end

  describe 'when logged in as user' do
    let(:user) { create(:user) }

    before do
      driven_by(:selenium_chrome_headless)
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on 'Log in'
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
        expect(page).to have_content('Please, type positive value.')
        expect(LineItem.find_by(product_id: product.id).quantity).not_to eq(-1)
      end

      it 'type string in quantity field' do
        fill_in 'line_item_quantity', with: 'xyz'
        find('#line_item_quantity').native.send_keys :enter
        expect(LineItem.find_by(product_id: product.id).quantity).not_to eq('xyz')
      end
    end
  end
end