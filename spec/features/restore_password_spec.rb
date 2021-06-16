# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Restoring password' do
  let!(:user1) { create(:user) }

  describe 'User restore password' do
    it 'with correct email address' do
      visit root_path
      click_on 'Log in'
      click_on 'Forgot your password?'
      fill_in 'user_email', with: 'someemail@email.com'
      click_on 'Send me reset password instructions'
      expect(page).to have_content('You will receive an email')
    end

    it 'with incorrect email address' do
      visit root_path
      click_on 'Log in'
      click_on 'Forgot your password?'
      fill_in 'user_email', with: 'someemail1@email.com'
      click_on 'Send me reset password instructions'
      expect(page).to have_content('Email not found')
    end
  end
end
