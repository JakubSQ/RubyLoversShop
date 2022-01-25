# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Price filter', type: :system do
  let!(:product) { create :product }
  let!(:product1) { create :product }
  let!(:product2) { create :product }

  describe 'Admin/User/Guest is allowed to' do
    before do
      driven_by(:rack_test)
      visit root_path
    end

    context 'choose specific price range' do
      it 'gets all products within this range' do
        fill_in 'q_prize_gteq', with: product.prize
        fill_in 'q_prize_lteq', with: product1.prize
        click_on 'Search'

        expect(page).to have_content(product.prize)
        expect(page).to have_content(product1.prize)
        expect(page).not_to have_content(product2.prize)
      end
    end
  end
end
