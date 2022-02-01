# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OrderSaveAddress', type: :request do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }

  context 'when logged in as user' do
    let!(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    it "is allowed to get order's preview page" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
      post confirm_orders_path, params: { save_address: 1,
                                          user: { address_b: '' },
                                          order: { billing_address: { name: address.name,
                                                                      street_name1: address.street_name1,
                                                                      city: address.city,
                                                                      country: address.country,
                                                                      state: address.state,
                                                                      zip: address.zip,
                                                                      phone: address.phone,
                                                                      ship_to_bill: 1 } } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(address.name)
    end
  end

  context 'when logged in as admin' do
    let!(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    it "is not allowed to get order's preview page" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
      post confirm_orders_path, params: { save_address: 1,
                                          user: { address_b: '' },
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
      expect(response.body).not_to include(address.name)
    end
  end

  context 'when logged in as guest' do
    it "is allowed to get order's preview page" do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
      post confirm_orders_path, params: { save_address: 1,
                                          user: { address_b: '' },
                                          order: { billing_address: { name: address.name,
                                                                      street_name1: address.street_name1,
                                                                      city: address.city,
                                                                      country: address.country,
                                                                      state: address.state,
                                                                      zip: address.zip,
                                                                      phone: address.phone,
                                                                      ship_to_bill: 1 } } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(address.name)
    end
  end
end
