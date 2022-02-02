# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PathPresenter do
  let(:cart) { create(:cart) }
  let(:path) { '/' }
  let(:session) do
    { cart_id: cart.id }
  end
  let(:request) { "/carts/#{session[:cart_id]}" }
  let(:user) { true }
  let(:path_presenter) { described_class.new(path, session, request, user) }

  context 'When path is a root path' do
    it "PathPresenter returns 'active'" do
      expect(path_presenter.home).to eq('active')
    end
  end

  context 'When path is not a root path' do
    let(:path) { '/carts' }

    it 'PathPresenter returns nil' do
      expect(path_presenter.home).to eq(nil)
    end
  end

  context 'When path is a carts path' do
    let(:path) { "/carts/#{cart.id}" }

    it "PathPresenter returns 'active'" do
      expect(path_presenter.cart).to eq('active')
    end
  end

  context 'When path is not a carts path' do
    it 'PathPresenter returns nil' do
      expect(path_presenter.cart).to eq(nil)
    end
  end

  context 'When request referer includes carts path' do
    let(:path) { "/carts/#{cart.id}" }

    it 'PathPresenter returns true' do
      expect(path_presenter.skip?).to eq(true)
    end
  end

  context 'When request referer not includes carts path' do
    let(:path) { "/carts/#{cart.id}" }
    let(:request) { '/' }

    it 'PathPresenter returns false' do
      expect(path_presenter.skip?).to eq(false)
    end
  end

  context 'When user is signed in' do
    let(:path) { "/carts/#{cart.id}" }
    let(:request) { '/' }

    it 'PathPresenter returns new_order_path' do
      expect(path_presenter.path).to eq('/orders/new')
    end
  end

  context 'When user is not signed in' do
    let(:path) { "/carts/#{cart.id}" }
    let(:request) { '/' }
    let(:user) { false }

    it 'PathPresenter returns new_user_session_path' do
      expect(path_presenter.path).to eq('/users/sign_in')
    end
  end
end
