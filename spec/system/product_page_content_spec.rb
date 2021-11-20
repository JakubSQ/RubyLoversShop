# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Product page content', type: :system do
  let!(:product) { create :product }

  context 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      driven_by(:rack_test)
      sign_in admin
      visit root_path
    end

    it 'gets product page content by clicking on product title' do
      click_on product.name
      expect(page).to have_content(product.prize.to_s)
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_css("img[src*='coat.jpg']")
    end

    it 'gets product page content by clicking on product photo' do
      find("img[src*='coat.jpg']").click
      expect(page).to have_content(product.prize.to_s)
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_css("img[src*='coat.jpg']")
    end
  end

  context 'when logged in as user' do
    let(:user) { create(:user) }

    before do
      driven_by(:rack_test)
      sign_in user
      visit root_path
    end

    it 'gets product page content by clicking on product title' do
      click_on product.name
      expect(page).to have_content(product.prize.to_s)
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_css("img[src*='coat.jpg']")
    end

    it 'gets product page content by clicking on product photo' do
      find("img[src*='coat.jpg']").click
      expect(page).to have_content(product.prize.to_s)
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_css("img[src*='coat.jpg']")
    end
  end

  context 'without logging in' do
    before do
      driven_by(:rack_test)
      visit root_path
    end

    it 'gets product page content by clicking on product title' do
      click_on product.name
      expect(page).to have_content(product.prize.to_s)
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_css("img[src*='coat.jpg']")
    end

    it 'gets product page content by clicking on product photo' do
      find("img[src*='coat.jpg']").click
      expect(page).to have_content(product.prize.to_s)
      expect(page).to have_content(product.name)
      expect(page).to have_content(product.description)
      expect(page).to have_css("img[src*='coat.jpg']")
    end
  end
end
