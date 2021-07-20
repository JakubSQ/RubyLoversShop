# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AddingItemToCart', type: :system do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }

  before do
    driven_by(:rack_test)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'
  end

  it 'user can add item to cart from homepage' do
    visit root_path
    click_on product.name
    click_button 'Add to cart'
    expect(page).to have_content('Item added to cart')
    expect(page).to have_content(product.name)
  end

  it 'user can add item to cart from /products' do
    visit products_path
    click_on product.name
    click_button 'Add to cart'
    expect(page).to have_content('Item added to cart')
    expect(page).to have_content(product.name)
  end

  it 'user checkout order list' do
    visit root_path
    click_on product.name
    click_button 'Add to cart'
    click_on 'Checkout'
    click_on 'Confirm checkout'
    expect(page).to have_content('Order successfully created')
  end
end
