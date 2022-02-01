# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderSaveAddress', type: :request do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }
  let(:params) do
    { save_address: '',
      user: { address_b: '' },
      order: { billing_address: { name: address.name,
                                  street_name1: address.street_name1,
                                  city: address.city,
                                  country: address.country,
                                  state: address.state,
                                  zip: address.zip,
                                  phone: address.phone,
                                  ship_to_bill: 1 } } }
  end

  describe 'when logged in as user' do
    let!(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'is allowed to' do
      it 'checkout an order' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: params

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

    context 'is not allowed to' do
      it 'save address during checkout' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: params

        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(0)
      end
    end
  end

  describe 'when logged in as guest' do
    context 'is allowed to' do
      let(:params) do
        { save_address: '',
          user: { address_b: '', email: 'example@email.com' },
          order: { billing_address: { name: address.name,
                                      street_name1: address.street_name1,
                                      city: address.city,
                                      country: address.country,
                                      state: address.state,
                                      zip: address.zip,
                                      phone: address.phone,
                                      ship_to_bill: 1 } } }
      end

      it 'checkout an order' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: params

        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(1)
      end
    end
  end
end
