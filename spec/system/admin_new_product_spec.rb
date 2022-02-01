# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminAddingProducts', type: :system do
  let(:admin) { create(:admin) }
  let!(:category) { create(:category) }
  let!(:brand) { create(:brand) }
  let(:product) { build(:product) }

  before do
    driven_by(:rack_test)
    Capybara.current_session.driver.header 'Referer', 'http://example.com'
    visit new_admin_session_path
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: admin.password
    click_on 'Log in'
    visit admin_root_path
    click_on 'Add new product'
  end

  it 'allows admin to add a new product' do
    fill_in 'product_name', with: product.name
    fill_in 'product_prize', with: product.prize
    select category.title, from: 'product_category_id'
    select brand.title, from: 'product_brand_id'
    click_button 'Create Product'
    expect(page).to have_content('Product has been successfully created.')
    expect(page).to have_content(product.name)
  end

  it 'prevents admin to add a new product without name' do
    fill_in 'product_name', with: ' '
    fill_in 'product_prize', with: product.prize
    select category.title, from: 'product_category_id'
    select brand.title, from: 'product_brand_id'
    click_button 'Create Product'
    expect(page).to have_content('Product has not been created.')
    expect(page).to have_no_content(product.name)
  end

  it 'prevents admin to add a new product without prize' do
    fill_in 'product_name', with: product.name
    fill_in 'product_prize', with: ' '
    select category.title, from: 'product_category_id'
    select brand.title, from: 'product_brand_id'
    click_button 'Create Product'
    expect(page).to have_content('Product has not been created.')
    expect(page).to have_no_content(product.name)
  end
end
