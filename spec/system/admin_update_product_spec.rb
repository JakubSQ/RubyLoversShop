# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminUpdatingProducts', type: :system do
  let!(:admin) { create(:admin) }
  let!(:product) { create(:product) }
  let!(:updated_product) { build(:product, name: 'trousers', prize: 10) }

  before do
    driven_by(:rack_test)
    Capybara.current_session.driver.header 'Referer', 'http://example.com'
    visit new_admin_session_path
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: admin.password
    click_on 'Log in'
    visit admin_root_path
    click_on 'Edit'
  end

  it 'allows admin to update product name' do
    fill_in 'product_name', with: updated_product.name
    fill_in 'product_prize', with: product.prize
    click_button 'Update Product'
    expect(page).to have_content('Product has been successfully updated.')
    expect(page).to have_content(updated_product.name)
    expect(page).to have_no_content(product.name)
  end

  it 'allows admin to update product prize' do
    fill_in 'product_name', with: product.name
    fill_in 'product_prize', with: updated_product.prize
    click_button 'Update Product'
    expect(page).to have_content('Product has been successfully updated.')
    expect(page).to have_no_field('product_prize', with: product.prize)
  end

  it 'prevents admin to update product without name' do
    fill_in 'product_name', with: ' '
    fill_in 'product_prize', with: product.prize
    click_button 'Update Product'
    expect(page).to have_content("Name can't be blank")
  end

  it 'prevents admin to update product without prize' do
    fill_in 'product_name', with: product.name
    fill_in 'product_prize', with: ' '
    click_button 'Update Product'
    expect(page).to have_content("Prize can't be blank")
  end
end
