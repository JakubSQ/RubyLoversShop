# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderAddress', type: :request do
  let(:shipping_method) { create(:shipping_method) }
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let(:address1) { create(:address) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }

  describe 'when logged in as user' do
    let!(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'is not allowed to create order' do
      it 'with only one address and unchecked checkbox' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { user: { address_b: '' },
                                    shipment: { shipment_id: shipping_method.id },
                                    order: { billing_address: { name: address.name,
                                                                street_name1: address.street_name1,
                                                                city: address.city,
                                                                country: address.country,
                                                                state: address.state,
                                                                zip: address.zip,
                                                                phone: address.phone,
                                                                ship_to_bill: 0 } } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(0)
      end
    end

    context 'is allowed to create order' do
      it 'with only one address and checked checkbox' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { save_address: '',
                                    user: { address_b: '' },
                                    shipment: { shipment_id: shipping_method.id },
                                    order: { billing_address: { name: address.name,
                                                                street_name1: address.street_name1,
                                                                city: address.city,
                                                                country: address.country,
                                                                state: address.state,
                                                                zip: address.zip,
                                                                phone: address.phone,
                                                                ship_to_bill: 1 } } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(1)
      end

      it 'with two seperate addresses' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { save_address: '',
                                    user: { address_b: '' },
                                    shipment: { shipment_id: shipping_method.id },
                                    order: { billing_address: { name: address.name,
                                                                street_name1: address.street_name1,
                                                                city: address.city,
                                                                country: address.country,
                                                                state: address.state,
                                                                zip: address.zip,
                                                                phone: address.phone,
                                                                ship_to_bill: 0 },
                                             shipping_address: { name: address1.name,
                                                                 street_name1: address1.street_name1,
                                                                 city: address1.city,
                                                                 country: address1.country,
                                                                 state: address1.state,
                                                                 zip: address1.zip,
                                                                 phone: address1.phone } } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(1)
      end
    end
  end

  describe 'when logged in as admin' do
    let!(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'is not allowed to create order' do
      it 'with correct address data' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { user: { address_b: '' },
                                    shipment: { shipment_id: shipping_method.id },
                                    order: { billing_address: { name: address.name,
                                                                street_name1: address.street_name1,
                                                                city: address.city,
                                                                country: address.country,
                                                                state: address.state,
                                                                zip: address.zip,
                                                                phone: address.phone } } }
        follow_redirect!
        expect(Order.count).to eq(0)
      end
    end
  end

  describe 'without logging in' do
    context 'guest is not allowed to create order' do
      it 'with correct address data' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { user: { address_b: '', email: 'guest@com.pl' },
                                    shipment: { shipment_id: shipping_method.id },
                                    order: { billing_address: { name: address.name,
                                                                street_name1: address.street_name1,
                                                                city: address.city,
                                                                country: address.country,
                                                                state: address.state,
                                                                zip: address.zip,
                                                                phone: address.phone } } }
        follow_redirect!
        expect(Order.count).to eq(0)
      end
    end
  end
end
