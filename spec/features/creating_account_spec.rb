# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating account' do
  describe 'User creating new account' do
    it 'page includes welcome notice' do
      visit root_path
      click_on 'Sign up'
      fill_in 'user_email', with: 'someemail@email.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Sign up'
      expect(page).to have_content('Welcome')
    end

    it 'page does not include welcome notice' do
      visit root_path
      click_on 'Sign up'
      fill_in 'user_email', with: 'someemail@email.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: ' '
      click_button 'Sign up'
      expect(page).not_to have_content('Welcome')
    end
  end
end
