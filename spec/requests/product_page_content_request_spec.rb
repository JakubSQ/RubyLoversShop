# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProductPage', type: :request do
  describe 'GET products#show' do
    let(:product) { create :product }

    context 'when logged in as admin' do
      let(:admin) { create(:admin) }

      it 'gets product page content' do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
        get "/products/#{product.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(product.prize.to_s)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.description)
        expect(product.cover_photo).to be_attached
        expect(response.body).to include('coat.jpg')
      end
    end

    context 'when logged in as user' do
      let(:user) { create(:user) }

      it 'gets product page content' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        get "/products/#{product.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(product.prize.to_s)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.description)
        expect(product.cover_photo).to be_attached
        expect(response.body).to include('coat.jpg')
      end
    end

    context 'without logging in' do
      it 'gets product page content' do
        get "/products/#{product.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(product.prize.to_s)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.description)
        expect(product.cover_photo).to be_attached
        expect(response.body).to include('coat.jpg')
      end
    end
  end
end
