# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderShipmentStatus', type: :request do
  let(:user) { create(:user) }
  let(:address) { create(:address) }
  let(:shipment) { create(:shipment) }
  let(:payment) { create(:payment) }
  let(:order) { create(:order, user: user,
                               payment: payment,
                               shipment: shipment,
                               billing_address_id: address.id,
                               shipping_address_id: address.id) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'is allowed to' do
      it "gets order's page with order's shipment status" do
        get "/admin/orders/#{order.id}"
        expect(response).to have_http_status(:ok)
        expect(shipment).to have_state(:pending)
      end

      it "change an order's shipment status from 'pending' to 'ready'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        shipment.reload
        expect(response).to have_http_status(:ok)
        expect(shipment).to have_state(:ready)
      end

      it "change an order's shipment status from 'pending' to 'canceled'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=canceled"
        shipment.reload
        expect(response).to have_http_status(:ok)
        expect(shipment).to have_state(:canceled)
      end

      it "change an order's shipment status from 'ready' to 'failed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=failed"
        shipment.reload
        expect(response).to have_http_status(:ok)
        expect(shipment).to have_state(:failed)
      end

      it "change an order's shipment status from 'ready' to 'shipped' if payment status is 'completed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/payment_status?aasm_state=completed"
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=shipped"
        shipment.reload
        expect(shipment).to have_state(:shipped)
      end
    end

    context 'is not allowed to' do
      it "change an order's shipment status from 'ready' to 'shipped' if payment status is not 'completed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=shipped"
        shipment.reload
        expect(shipment).not_to allow_event :delivered
      end
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
    it 'is not allowed to visit order page' do
      get "/admin/orders/#{order.id}"
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end
end
