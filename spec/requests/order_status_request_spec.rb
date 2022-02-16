# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminOrderStatus', type: :request do
  let(:user) { create(:user) }
  let(:address) { create(:address) }
  let(:shipping_method) { create(:shipping_method) }
  let(:shipment) do
    create(:shipment, name: shipping_method.name,
                      price: shipping_method.price,
                      delivery_time: shipping_method.delivery_time)
  end
  let(:payment) { create(:payment) }
  let(:order) do
    create(:order, user: user,
                   payment: payment,
                   shipment: shipment,
                   billing_address_id: address.id,
                   shipping_address_id: address.id)
  end

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'you are allowed to' do
      it "gets order's page with order's status" do
        get "/admin/orders/#{order.id}"
        expect(response).to have_http_status(:ok)
        expect(order).to have_state(:new)
      end

      it "change an order's status from 'new' to 'failed'" do
        patch "/admin/orders/#{order.id}/order_status?state=failed"
        expect(response).to have_http_status(:ok)
        order.reload
        expect(order).to have_state(:failed)
      end
    end

    context "when shipment status is 'shipped' and payment status is 'completed'" do
      it "is allowed to change order status to 'completed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=shipped"
        patch "/admin/orders/#{order.id}/payment_status?aasm_state=completed"
        patch "/admin/orders/#{order.id}/order_status?state=completed"
        order.reload
        expect(order).to have_state(:completed)
      end
    end

    context "when shipment status isn't 'shipped' and payment status isn't 'completed'" do
      it "is not allowed to change order status to 'completed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/payment_status?aasm_state=pending"
        order.reload
        expect(order).not_to allow_event :done
      end
    end

    context "when shipment status isn't 'shipped' and payment status is 'completed'" do
      it "is not allowed to change order status to 'completed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/payment_status?aasm_state=completed"
        order.reload
        expect(order).not_to allow_event :done
      end
    end

    context "when shipment status is 'shipped' and payment status isn't 'completed'" do
      it "is not allowed to change order status to 'completed'" do
        patch "/admin/orders/#{order.id}/shipment_status?aasm_state=ready"
        patch "/admin/orders/#{order.id}/payment_status?aasm_state=completed"
        order.reload
        expect(order).not_to allow_event :done
      end
    end
  end

  describe 'when logged in as user' do
    it 'is not allowed to visit order page' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      get '/admin/orders'
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end

  describe 'when guest visits app' do
    it 'is not allowed to visit order page' do
      get "/admin/orders/#{order.id}"
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end
end
