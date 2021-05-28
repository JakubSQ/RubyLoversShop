require "rails_helper"

RSpec.feature "Category filter" do
  let!(:product_1) { create(:product) }
  let!(:product_2) { create(:product, name: "trousers", category: category_1) }
  let!(:product_3) { create(:product, name: "hat", category: category_2) }
  let!(:category_1) { create(:category, title: "men") }
  let!(:category_2) { create(:category, title: "unisex") }
  scenario "user sees only one category" do
    visit root_path
    click_on "Women"
    expect(page).to have_content('coat')
    expect(page).not_to have_content('spodnie')
    expect(page).not_to have_content('hat')
  end
end
