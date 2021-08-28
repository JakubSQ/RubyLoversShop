# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPaymentStatus', type: :request do
  let(:user) { create(:user) }
  let(:payment) { create(:payment) }
  let(:order) { create(:order, user: user, payment: payment) }

  context 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    it "gets order's page with order's payment status" do
      get "/admin/orders/#{order.id}"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(order.payment.aasm_state.to_s)
    end

    it "admin can change an order's payment status from 'pending' to 'failed'" do
      patch "/admin/orders/#{order.id}/payment_status?aasm_state=failed"
      payment.reload
      expect(response).to have_http_status(:ok)
      expect(payment).to have_state(:failed)
    end

    it "admin can change an order's payment status from 'pending' to 'completed'" do
      patch "/admin/orders/#{order.id}/payment_status?aasm_state=completed"
      payment.reload
      expect(response).to have_http_status(:ok)
      expect(payment).to have_state(:completed)
    end
  end

  context 'when logged in as user' do
    it 'is not allowed to visit order page' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      get '/admin/orders'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end

  context 'when guest visits app' do
    it 'guest is not allowed to visit order page' do
      get "/admin/orders/#{order.id}"
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end
end
