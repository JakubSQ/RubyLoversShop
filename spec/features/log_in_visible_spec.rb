# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log in form on navbar', type: :view do

  describe 'application/navigation' do
    it 'displays the log in form' do
      render partial: 'application/navigation'
      expect(rendered).to have_content 'Log in'
    end

    it 'does not display the log out form' do
      render partial: 'application/navigation'
      expect(rendered).not_to have_content 'Log out'
    end
  end
end
