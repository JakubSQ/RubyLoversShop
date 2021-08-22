# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderStatus', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let(:shipment) { create(:shipment) }
  let(:payment) { create(:payment) }
  let!(:order) { create(:order, user_id: user.id, payment_id: payment.id, shipment_id: shipment.id) }

  describe 'when logged in as admin' do
    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'you are allowed to'
    it "gets order's page with order's status" do
      get "/admin/orders/#{Order.last.id}"
      expect(response).to have_http_status(:ok)
      expect(order).to have_state(:new)
    end

    it "change an order's status from 'new' to 'failed'" do
      patch "/admin/orders/#{Order.last.id}/order_status?state=failed"
      expect(response).to have_http_status(:ok)
      expect(Order.last).to have_state(:failed)
    end

    context "you have permission to change order status to 'completed' only if" do
      it "shipment status is 'shipped' and payment status is 'completed'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=shipped"
        patch "/admin/orders/#{Order.last.id}/payment_status?aasm_state=completed"
        patch "/admin/orders/#{Order.last.id}/order_status?state=completed"
        expect(Order.last).to have_state(:completed)
      end
    end

    context "you don't have permission to change order status to 'completed' if" do
      it "shipment status isn't 'shipped' and payment status isn't 'completed'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{Order.last.id}/payment_status?aasm_state=pending"
        expect(Order.last).not_to allow_event :done
      end

      it "shipment status isn't 'shipped' and payment status is 'completed'" do
        patch "/admin/orders/#{Order.last.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{Order.last.id}/payment_status?aasm_state=completed"
        expect(Order.last).not_to allow_event :done
      end
    end
  end

  describe 'when logged in as user' do
    it 'user is not allowed to visit order page' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      get '/admin/orders'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end

  describe 'without logging in' do
    it 'visitor is not allowed to visit order page' do
      get "/admin/orders/#{Order.last.id}"
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end
end
