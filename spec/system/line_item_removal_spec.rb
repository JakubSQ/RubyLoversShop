# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LineItemQuantity', type: :system do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      sign_in admin
      visit product_path(product)
      fill_in 'quantity', with: 10
      click_on 'Add to cart'
    end

    context 'is allowed to' do
      it 'remove product from cart regardless of items of this product' do
        click_on 'Remove'
        expect(page).to have_content('Your shopping cart is empty')
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end
    end
  end

  describe 'when logged in as user' do
    let(:user) { create(:user) }

    before do
      driven_by(:rack_test)
      sign_in user
      visit product_path(product)
      fill_in 'quantity', with: 10
      click_on 'Add to cart'
    end

    context 'is allowed to' do
      it 'remove product from cart regardless of items of this product' do
        click_on 'Remove'
        expect(page).to have_content('Your shopping cart is empty')
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
