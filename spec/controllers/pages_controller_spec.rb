# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET home' do
    let!(:product) { build(:product) }

    render_views

    it 'renders product name in body' do
      get :home
      expect(response.body).to include('Coat')
    end

    it 'renders product description in body' do
      get :home
      expect(response.body).to include('cotton coat')
    end

    it 'renders product photo in body' do
      get :home
      expect(response.body).to include('coat.jpg')
    end
  end
end
