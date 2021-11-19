# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LineItemQuantity', type: :system do
  let(:product) { create(:product) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      sign_in admin
      visit product_path(product)
    end

    context 'is allowed to' do
      it 'choose quantity of products to buy' do
        fill_in 'quantity', with: 1
        click_on 'Add to cart'
        expect(page).to have_content('Item added to cart')
        expect(LineItem.find_by(product_id: product.id)).not_to eq(nil)
      end
    end

    context 'is not allowed to' do
      it 'type negative value in quantity field' do
        fill_in 'quantity', with: -1
        click_on 'Add to cart'
        expect(page).to have_content('Please, type positive value')
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end

      it 'type string in quantity field' do
        fill_in 'quantity', with: 'xyz'
        click_on 'Add to cart'
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
    end

    context 'is allowed to' do
      it 'choose quantity of products to buy' do
        fill_in 'quantity', with: 1
        click_on 'Add to cart'
        expect(page).to have_content('Item added to cart')
        expect(LineItem.find_by(product_id: product.id)).not_to eq(nil)
      end
    end

    context 'is not allowed to' do
      it 'type negative value in quantity field' do
        fill_in 'quantity', with: -1
        click_on 'Add to cart'
        expect(page).to have_content('Please, type positive value')
        expect(LineItem.find_by(product_id: product.id)).to eq(nil)
      end

      it 'type string in quantity field' do
        fill_in 'quantity', with: 'xyz'
        click_on 'Add to cart'
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
      it 'choose quantity of products to buy' do
        fill_in 'quantity', with: -1
        click_on 'Add to cart'
        expect(page).to have_content('You are not authorized')
      end
    end
  end
end
