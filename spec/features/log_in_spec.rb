# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logging in' do
  describe 'User log in' do
    let!(:user) { create(:user) }

    it 'with correct credentials' do
      visit root_path
      click_on 'Log in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
      expect(page).to have_content('Signed in successfully.')
    end

    it 'with incorrect email' do
      visit root_path
      click_on 'Log in'
      fill_in 'user_email', with: "johndoe@example.com"
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
      expect(page).not_to have_content('Signed in successfully.')
    end

    it 'with incorrect password' do
      visit root_path
      click_on 'Log in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password1'
      click_button 'Log in'
      expect(page).not_to have_content('Signed in successfully.')
    end
  end
end
