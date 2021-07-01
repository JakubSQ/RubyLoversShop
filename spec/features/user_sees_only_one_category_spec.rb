# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Category filter' do
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product, name: 'trousers', category: category1) }
  let!(:product3) { create(:product, name: 'hat', category: category2) }
  let!(:category1) { create(:category, title: 'men') }
  let!(:category2) { create(:category, title: 'unisex') }

  describe 'User sees only one category' do
    it 'page includes coat' do
      visit root_path
      click_on 'Women'
      expect(page).to have_content('coat')
    end

    it 'page does not include trousers' do
      visit root_path
      click_on 'Women'
      expect(page).not_to have_content('trousers')
    end

    it 'page does not include hat' do
      visit root_path
      click_on 'Women'
      expect(page).not_to have_content('hat')
    end
  end
end
