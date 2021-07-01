# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Product', type: :request do
  describe 'GET pages#home' do
    let!(:product) { create :product }

    context 'visit root path' do
      it 'gets name of the product' do
        get '/'
        expect(response.body).to include(product.name)
      end

      it 'gets prize of the product' do
        get '/'
        expect(response.body).to include(product.prize.to_s)
      end

      it 'gets description of the product' do
        get '/'
        expect(response.body).to include(product.description)
      end
    end
  end
end
