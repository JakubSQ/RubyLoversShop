# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Filter' do
  let(:product1) { create(:product) }
  let!(:product2) { create(:product, name: 'trousers', category: category1, brand: brand1) }
  let!(:product3) { create(:product, name: 'hat', category: category2, brand: brand2) }
  let(:category1) { create(:category) }
  let(:category2) { create(:category) }
  let(:brand1) { create(:brand) }
  let!(:brand2) { create(:brand) }

  describe 'User sees product with specific category and brand' do
    it 'page includes coat' do
      visit root_path
      select(category1.title, from: 'q_category_title_eq', match: :first)
      select(brand1.title, from: 'q_brand_title_eq', match: :first)
      click_button 'Search'
      expect(page).to have_content(product1.name)
    end

    it 'page not include trousers' do
      visit root_path
      select(category2.title, from: 'q_category_title_eq', match: :first)
      select(brand1.title, from: 'q_brand_title_eq', match: :first)
      click_button 'Search'
      expect(page).not_to have_content(product2.name)
    end

    it 'page not include hat' do
      visit root_path
      select(category2.title, from: 'q_category_title_eq', match: :first)
      select(brand1.title, from: 'q_brand_title_eq', match: :first)
      click_button 'Search'
      expect(page).not_to have_content(product1.name)
    end
  end
end
