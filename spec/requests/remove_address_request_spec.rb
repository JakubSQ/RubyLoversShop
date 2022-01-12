# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserRemoveAddress', type: :request do
  let(:cart) { create(:cart) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }

  context 'when logged in as user' do
    let(:user) { create(:user) }
    let(:address) { create(:address, user_id: user.id) }
    let!(:address1) { create(:address, user_id: user.id) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    it 'is allowed to remove address during checkout' do
      allow_any_instance_of(ActionDispatch::Request).to receive(:session) { { cart_id: cart.id } }
      patch remove_address_path, params: { address_id: address.id }

      expect(user.addresses.count).to eq(1)
    end
  end

  context 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    it 'is not able to get to checkout page' do
      get "/orders/new"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end

  context 'without logging in' do
    it 'guest is not able to get to checkout page' do
      get "/orders/new"

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end
end
