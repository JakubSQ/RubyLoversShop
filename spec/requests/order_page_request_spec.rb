# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPage', type: :request do
  describe 'GET orders#show' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let!(:order) { Order.create(user_id: user.id) }

    context 'when logged in as admin' do
      it "gets order's page" do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
        get "/admin/orders/#{Order.last.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(order.id.to_s)
      end
    end

    context 'when logged ii as user' do
      it 'does not get list of orders on orders page' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        get '/admin/orders'
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to '/'
      end
    end

    context 'without logging in' do
      it 'does not get list of orders on orders page' do
        get "/admin/orders/#{Order.last.id}"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to '/'
      end
    end
  end
end
