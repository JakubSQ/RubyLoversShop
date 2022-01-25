# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Category filter' do
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product, name: 'trousers', category: category1) }
  let!(:product3) { create(:product, name: 'hat', category: category2) }
  let(:category1) { create(:category, title: 'men') }
  let(:category2) { create(:category, title: 'unisex') }

  describe 'User/guest/admin is able to' do
    context 'choose only one category from the list' do
      it 'page includes only product1' do
        visit root_path
        select(Category.first.title, from: 'q_category_title_eq', match: :first)
        click_button 'Search'

        expect(page).to have_content(product1.name)
        expect(page).not_to have_content(product2.name)
        expect(page).not_to have_content(product3.name)
      end
    end

    context "choose 'None' from the list" do
      it 'page includes all products' do
        visit root_path
        select('None', from: 'q_category_title_eq', match: :first)
        click_button 'Search'

        expect(page).to have_content(product1.name)
        expect(page).to have_content(product2.name)
        expect(page).to have_content(product3.name)
      end
    end
  end
end
