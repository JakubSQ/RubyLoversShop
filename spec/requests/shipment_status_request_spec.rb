# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderPaymentStatus', type: :request do
  describe 'GET orders#show' do
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let!(:shipment) { create(:shipment) }
    let!(:payment) { create(:payment) }
    let!(:order) { create(:order, user_id: user.id, payment_id: payment.id, shipment_id: shipment.id) }

    context 'when logged in as admin' do
      before do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
      end

      it "gets order's page with order's shipment status" do
        get "/admin/orders/#{Order.last.id}"
        expect(response).to have_http_status(:ok)
        expect(shipment).to have_state(:pending)
      end

      it "admin can change an order's shipment status from 'pending' to 'ready'" do
        # patch shipment_status_admin_order_path(order), params: { shipment: { aasm_state: :ready } }
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        expect(response).to have_http_status(:ok)
        expect(Shipment.last).to have_state(:ready)
      end

      it "admin can change an order's shipment status from 'pending' to 'canceled'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=canceled"
        expect(response).to have_http_status(:ok)
        expect(Shipment.last).to have_state(:canceled)
      end

      it "admin can change an order's shipment status from 'ready' to 'failed'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=failed"
        expect(response).to have_http_status(:ok)
        expect(Shipment.last).to have_state(:failed)
      end

      it "admin cannot change an order's shipment status from 'ready' to 'shipped' if payment status is not 'completed'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=shipped"
        expect(Shipment.last).not_to allow_event :delivered
      end

      it "admin can change an order's shipment status from 'ready' to 'shipped' if payment status is 'completed'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{Order.last.id}/payment_status?aasm_state=completed"
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=shipped"
        expect(Shipment.last).to have_state(:shipped)
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
