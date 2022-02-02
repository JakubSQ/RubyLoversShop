# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log in form on navbar', type: :view do
  let(:cart) { create(:cart) }
  let(:path) { '/' }
  let(:session) do
    { cart_id: cart.id }
  end
  let(:request) { "/carts/#{session[:cart_id]}" }
  let(:user) { true }

  describe 'application/navigation' do
    it 'displays the log in form' do
      @path_presenter = PathPresenter.new(path, session, request, user)
      render partial: 'application/navigation'
      expect(rendered).to have_content 'Log in'
    end

    it 'does not display the log out form' do
      @path_presenter = PathPresenter.new(path, session, request, user)
      render partial: 'application/navigation'
      expect(rendered).not_to have_content 'Log out'
    end
  end
end
