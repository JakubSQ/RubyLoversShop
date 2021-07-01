# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET home' do
    let!(:product) { create(:product) }

    render_views

    it 'renders product name in body' do
      get :home
      expect(response.body).to include(product.name)
    end

    it 'renders product description in body' do
      get :home
      expect(response.body).to include(product.description)
    end

    it 'renders product prize in body' do
      get :home
      expect(response.body).to include(product.prize)
    end
  end
end
