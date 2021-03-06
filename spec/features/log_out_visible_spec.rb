# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log out form visible on view' do
  describe 'User log in' do
    let!(:user) { create(:user) }

    it 'with correct credentials' do
      visit root_path
      click_on 'Log in'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Log in'
      expect(page).to have_content('Log out')
    end
  end
end
