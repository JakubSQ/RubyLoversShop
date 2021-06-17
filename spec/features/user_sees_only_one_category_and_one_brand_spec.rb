# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Filter' do
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product, name: 'trousers', category: category1, brand: brand1) }
  let!(:product3) { create:product, name: 'hat', category: category2, brand: brand2) }
  let!(:category1) { create(:category, title: 'men') }
  let!(:category2) { create(:category, title: 'women') }
  let!(:brand1) { create(:brand, title: 'nike') }
  let!(:brand2) { create(:brand, title: 'zara') }

  describe 'User sees product with specific category and brand' do
    it 'page includes coat' do
      visit root_path
      select('women', from: 'q_category_title_eq', match: :first)
      select('nike', from: 'q_brand_title_eq', match: :first)
      click_button 'Search'
      expect(page).to have_content('coat')
    end

    it 'page not include trousers' do
      visit root_path
      select('women', from: 'q_category_title_eq', match: :first)
      select('nike', from: 'q_brand_title_eq', match: :first)
      click_button 'Search'
      expect(page).not_to have_content('trousers')
    end

    it 'page not include hat' do
      visit root_path
      select('women', from: 'q_category_title_eq', match: :first)
      select('nike', from: 'q_brand_title_eq', match: :first)
      click_button 'Search'
      expect(page).not_to have_content('hat')
    end
  end
end
