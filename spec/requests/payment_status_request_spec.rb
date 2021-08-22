# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPaymentStatus', type: :request do
  describe 'GET orders#show' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let!(:payment) { create(:payment) }
    let!(:order) { create(:order, user_id: user.id, payment_id: payment.id) }

    context 'when logged in as admin' do
      before do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
      end

      it "gets order's page with order's payment status" do
        get "/admin/orders/#{Order.last.id}"
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(order.payment.aasm_state.to_s)
      end

      it "admin can change an order's payment status from 'pending' to 'failed'" do
        patch "/admin/orders/#{Order.last.id}/payment_status?aasm_state=failed"
        expect(response).to have_http_status(:ok)
        expect(Payment.last).to have_state(:failed)
      end

      it "admin can change an order's payment status from 'pending' to 'completed'" do
        patch "/admin/orders/#{Order.last.id}/payment_status?aasm_state=completed"
        expect(response).to have_http_status(:ok)
        expect(Payment.last).to have_state(:completed)
      end
    end

    context 'when logged in as user' do
      it 'user is not allowed to visit order page' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        get '/admin/orders'
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to '/'
      end
    end

    context 'without logging in' do
      it 'visitor is not allowed to visit order page' do
        get "/admin/orders/#{Order.last.id}"
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to '/'
      end
    end
  end
end
