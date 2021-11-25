# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderAddress', type: :request do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }

  describe 'when logged in as user' do
    let!(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'is allowed to create order' do
      it 'with correct address data' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { order: { address: { name: address.name,
                                                        street_name1: address.street_name1,
                                                        city: address.city,
                                                        country: address.country,
                                                        state: address.state,
                                                        zip: address.zip,
                                                        phone: address.phone } } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.last.billing_address).to be_present
      end
    end
  end

  describe 'when logged in as admin' do
    let!(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'is allowed to create order' do
      it 'with correct address data' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
        post orders_path, params: { order: { address: { name: address.name,
                                                        street_name1: address.street_name1,
                                                        city: address.city,
                                                        country: address.country,
                                                        state: address.state,
                                                        zip: address.zip,
                                                        phone: address.phone } } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(Order.last.billing_address).to be_present
      end
    end
  end
end
