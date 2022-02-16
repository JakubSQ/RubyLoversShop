# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPage', type: :request do
  describe 'GET orders#show' do
    let(:address) { create(:address) }
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let!(:payment) { create(:payment) }
    let!(:order) do
      create(:order, user_id: user.id,
                     payment_id: payment.id,
                     billing_address_id: address.id,
                     shipping_address_id: address.id)
    end

    context 'when logged in as admin' do
      it "gets order's page" do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
        get "/admin/orders/#{Order.last.id}"

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(order.id.to_s)
      end
    end

    context 'when logged in as user' do
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
