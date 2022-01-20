# frozen_string_literal: true
# # frozen_string_literal: true

# require 'rails_helper'
# require 'selenium-webdriver'

# RSpec.describe 'Remove address during checkout', type: :system, js: true do
#   let!(:product) { create(:product) }

#   before do
#     driven_by(:selenium_chrome_headless)
#   end

#   context 'When logged in as user' do
#     let(:user) { create(:user) }
#     let!(:address) { create(:address, user_id: user.id) }
#     let!(:address1) { create(:address, user_id: user.id) }

#     it 'is allowed to remove address during checkout' do
#       sign_in user
#       visit root_path
#       click_on product.name
#       click_button 'Add to cart'
#       click_on 'Checkout'
#       select(address.name.to_s, from: 'user_address_b', match: :first)
#       click_on 'Remove address'
#       user.reload

#       expect(page).to have_content('Address has been removed')
#       expect(user.addresses.count).to eq(1)
#     end
#   end

#   context 'When logged in as admin' do
#     let(:admin) { create(:admin) }

#     it 'is not able to get to checkout page' do
#       sign_in admin
#       visit root_path
#       click_on product.name
#       click_button 'Add to cart'
#       click_on 'Checkout'
#       expect(page).to have_content('Admin cannot checkout order')
#     end
#   end

#   context 'Without logging in' do
#     it 'guest is not able to get to checkout page' do
#       visit root_path
#       click_on product.name
#       click_button 'Add to cart'
#       expect(page).to have_content('You are not authorized')
#     end
#   end
# end
